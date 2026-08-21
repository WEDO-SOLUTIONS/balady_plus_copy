import CarPlay
import DGis

class FavoritesScreen {
    unowned private let listTemplate: CPListTemplate
    private let interfaceController: CPInterfaceController
    private let hostFlutterApi: HostFlutterApi
    private let searchNavigation: SearchNavigation

    private var lists: [FavoriteListMessage] = []
    private var expandedListIds: Set<String> = []

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
        listTemplate.emptyViewTitleVariants = [
            NSLocalizedString("favouritesScreenLoadingPlaceholder", comment: "")
        ]
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
                items += list.items.isEmpty
                    ? [makeEmptyListPlaceholderItem()]
                    : list.items.map(makePlaceItem)
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
        }
        renderSections()
    }

    private func makePlaceItem(_ item: FavoriteListItemMessage) -> CPListItem {
        let listItem = CPListItem(text: item.title, detailText: item.subtitle ?? "")
        listItem.userInfo = item
        listItem.handler = onPlaceItemTap
        return listItem
    }

    private func onPlaceItemTap(listItem: CPSelectableListItem, completion: @escaping () -> Void) {
        defer { completion() }
        guard let item = listItem.userInfo as? FavoriteListItemMessage else { return }
        searchNavigation.navigate(
            to: item.coordinates.geoPoint,
            destinationName: listItem.text ?? item.title,
            additionalInformation: item.subtitle ?? ""
        )
        interfaceController.popToRootTemplate(animated: true) { _, __ in }
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
