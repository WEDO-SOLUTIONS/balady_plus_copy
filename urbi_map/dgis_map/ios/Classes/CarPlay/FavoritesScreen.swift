import CarPlay
import DGis

class FavoritesScreen {
    unowned private let listTemplate: CPListTemplate
    private let interfaceController: CPInterfaceController
    private let hostFlutterApi: HostFlutterApi
    private let searchNavigation: SearchNavigation

    private var lists: [FavoriteListMessage] = []
    private var expandedListIds: Set<String> = []

    // Places are resolved natively via `searchManager` — the car session's own SDK search
    // service, independent of the phone's Flutter map — instead of over Pigeon, so each place's
    // `DirectoryObject` arrives asynchronously per-item rather than all at once with the list
    // payload. Mirrors the Android Auto `FavoriteListsScreen.kt` implementation.
    private let searchManager: SearchManager
    private var resolvedPlaces: [String: DirectoryObject] = [:]
    private var failedPlaceIds: Set<String> = []
    // Must keep each request's Cancellable alive until completion, otherwise the SDK's required
    // strong reference is dropped and the completion silently never fires (see the identical
    // comment on `SearchHandler.objectSearchCancelables`).
    private var resolvingCancelables: [String: DGis.Cancellable] = [:]

    init(
        listTemplate: CPListTemplate,
        interfaceController: CPInterfaceController,
        hostFlutterApi: HostFlutterApi,
        searchNavigation: SearchNavigation
    ) {
        self.listTemplate = listTemplate
        self.interfaceController = interfaceController
        self.hostFlutterApi = hostFlutterApi
        self.searchNavigation = searchNavigation
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        self.searchManager = try! SearchManager.createOnlineManager(context: try! sdk.context)
    }

    static func createTemplate() -> CPListTemplate {
        CPListTemplate(
            title: NSLocalizedString("favouritesScreenTitle", comment: ""),
            sections: []
        )
    }

    func show() {
        listTemplate.backButton = CPBarButton(
            title: NSLocalizedString("favouritesScreenBackButton", comment: ""),
            handler: onBackTap
        )
        listTemplate.updateSections([loadingSection()])
        hostFlutterApi.getFavoriteLists(completion: onResult)
        listTemplate.show(with: interfaceController)
    }

    private func onResult(result: Result<FavoriteListsStateMessage, PigeonError>) {
        switch result {
        case .success(let favoriteListsState):
            self.lists = favoriteListsState.lists
            self.expandedListIds = []
            renderSections()
        case .failure(let error):
            self.listTemplate.emptyViewTitleVariants = [
                String(describing: error)
            ]
        }
    }

    private func renderSections() {
        guard !lists.isEmpty else {
            listTemplate.updateSections([emptyStateSection()])
            return
        }

        let sections = lists.enumerated().map { index, list -> CPListSection in
            let isExpanded = expandedListIds.contains(list.id)
            var items = [makeListHeaderItem(for: list, isExpanded: isExpanded)]
            if isExpanded {
                items += list.placeRefs.isEmpty
                    ? [makeEmptyListPlaceholderItem()]
                    : list.placeRefs.map(makePlaceRefItem)
            }
            return CPListSection(
                items: items,
                header: index == 0 ? NSLocalizedString("favouritesScreenMyListsHeader", comment: "") : nil,
                sectionIndexTitle: nil
            )
        }
        listTemplate.updateSections(sections)
    }

    // CarPlay re-tints CPListItem's leading `image` with its own system accent color when the
    // image still carries SF Symbol "template" semantics — even after `.alwaysOriginal`
    // tinting. Rasterizing it into a plain bitmap strips that residual template-ness so the
    // per-list color actually shows.
    private func flatBookmarkImage(colorHex: String) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        guard
            let symbol = UIImage(systemName: "bookmark.fill", withConfiguration: config)?
                .withTintColor(UIColor(hex: colorHex), renderingMode: .alwaysOriginal)
        else { return nil }

        return UIGraphicsImageRenderer(size: symbol.size).image { _ in
            symbol.draw(at: .zero)
        }
    }

    private func makeListHeaderItem(for list: FavoriteListMessage, isExpanded: Bool) -> CPListItem {
        let bookmarkImage = flatBookmarkImage(colorHex: list.colorHex)
        let chevronImage = UIImage(systemName: isExpanded ? "chevron.down" : "chevron.right")

        let item = CPListItem(
            text: list.name,
            detailText: list.subtitle,
            image: bookmarkImage,
            accessoryImage: chevronImage,
            accessoryType: .none
        )
        item.userInfo = ToggleListUserInfo(listId: list.id)
        item.handler = onHeaderTap
        return item
    }

    private func onHeaderTap(listItem: CPSelectableListItem, completion: @escaping () -> Void) {
        defer { completion() }
        guard let info = listItem.userInfo as? ToggleListUserInfo else { return }
        if expandedListIds.contains(info.listId) {
            expandedListIds.remove(info.listId)
        } else {
            expandedListIds.insert(info.listId)
            retryFailedPlaces(inList: info.listId)
        }
        renderSections()
    }

    // Re-expanding a list is the user's retry gesture: clear this list's failed ids so
    // `makePlaceRefItem` falls through to `resolvePlace` again instead of showing
    // "unavailable" forever (place resolution has no other in-session refresh path).
    private func retryFailedPlaces(inList listId: String) {
        guard let list = lists.first(where: { $0.id == listId }) else { return }
        for placeRef in list.placeRefs {
            failedPlaceIds.remove(placeRef.placeId)
        }
    }

    private func makePlaceRefItem(_ placeRef: FavoriteListPlaceRefMessage) -> CPListItem {
        if let resolved = resolvedPlaces[placeRef.placeId] {
            let listItem = CPListItem(text: placeRef.customName ?? resolved.title, detailText: resolved.addressString)
            listItem.userInfo = placeRef
            listItem.handler = onPlaceRefItemTap
            return listItem
        }

        if failedPlaceIds.contains(placeRef.placeId) {
            return CPListItem(text: NSLocalizedString("favouritesScreenPlaceUnavailable", comment: ""), detailText: nil)
        }

        if resolvingCancelables[placeRef.placeId] == nil {
            resolvePlace(placeRef)
        }
        return CPListItem(text: NSLocalizedString("favouritesScreenPlaceResolving", comment: ""), detailText: nil)
    }

    // Resolves natively via `searchManager` (independent of the phone's Flutter map) instead of
    // over Pigeon — this keeps favourite-place resolution working even when the phone's own map
    // screen was never opened this session.
    private func resolvePlace(_ placeRef: FavoriteListPlaceRefMessage) {
        guard let objectId = UInt64(placeRef.placeId) else {
            failedPlaceIds.insert(placeRef.placeId)
            return
        }

        let dgisObjectId = DgisObjectId(objectId: objectId, entranceId: 0)
        resolvingCancelables[placeRef.placeId] = searchManager.searchByDirectoryObjectId(objectId: dgisObjectId).sink {
            [weak self] directoryObject in
            guard let self else { return }
            self.resolvingCancelables[placeRef.placeId] = nil
            if let directoryObject {
                self.resolvedPlaces[placeRef.placeId] = directoryObject
            } else {
                self.failedPlaceIds.insert(placeRef.placeId)
            }
            self.renderSections()
        } failure: { [weak self] _ in
            guard let self else { return }
            self.resolvingCancelables[placeRef.placeId] = nil
            self.failedPlaceIds.insert(placeRef.placeId)
            self.renderSections()
        }
    }

    private func onPlaceRefItemTap(listItem: CPSelectableListItem, completion: @escaping () -> Void) {
        defer { completion() }
        guard
            let placeRef = listItem.userInfo as? FavoriteListPlaceRefMessage,
            let resolved = resolvedPlaces[placeRef.placeId]
        else { return }

        if let customName = placeRef.customName, let geoPoint = resolved.markerPosition?.point {
            searchNavigation.navigate(to: geoPoint, destinationName: customName, additionalInformation: resolved.addressString)
        } else {
            searchNavigation.navigate(to: resolved)
        }
        interfaceController.popToRootTemplate(animated: true) { _, __ in }
    }

    private func loadingSection() -> CPListSection {
        let placeholder = CPListItem(
            text: NSLocalizedString("favouritesScreenPlaceResolving", comment: ""),
            detailText: nil
        )
        return CPListSection(items: [placeholder])
    }

    private func emptyStateSection() -> CPListSection {
        let placeholder = CPListItem(
            text: NSLocalizedString("favouritesScreenPlaceholderEmptyTitle", comment: ""),
            detailText: NSLocalizedString("favouritesScreenPlaceholderEmptySubtitle", comment: "")
        )
        return CPListSection(items: [placeholder])
    }

    private func makeEmptyListPlaceholderItem() -> CPListItem {
        CPListItem(
            text: NSLocalizedString("favouritesScreenListEmptyPlaceholder", comment: ""),
            detailText: nil
        )
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }
}

private struct ToggleListUserInfo {
    let listId: String
}

private extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1
        )
    }
}
