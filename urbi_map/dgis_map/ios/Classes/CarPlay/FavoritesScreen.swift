import CarPlay
import Combine
import DGis

class FavoritesScreen {
    unowned private let listTemplate: CPListTemplate
    private let interfaceController: CPInterfaceController
    private let hostFlutterApi: HostFlutterApi
    private let searchNavigation: SearchNavigation

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
        hostFlutterApi.getFavourites(completion: onResult)
        listTemplate.show(with: interfaceController)
    }

    private func onResult(result: Result<FavouritesStateMessage, PigeonError>) {
        switch result {
        case .success(let favouritesStateMessage):
            showFavorites(favouritesStateMessage)
        case .failure(let error):
            self.listTemplate.emptyViewTitleVariants = [
                String(describing: error)
            ]
        }
    }

    private func showFavorites(
        _ favouritesStateMessage: FavouritesStateMessage
    ) {
        let emptyItemPlaceHolder = CPListItem(
            text: "favouritesScreenPlaceholderEmptyTitle".localized,
            detailText: "favouritesScreenPlaceholderEmptySubtitle".localized
        )
        emptyItemPlaceHolder.handler = onItemTap

        let sections = [
            CPListSection(
                items: [
                    mapCPListItem(
                        from: favouritesStateMessage.home,
                        title: "favouritesScreenItemTitleHome".localized,
                        image: UIImage(named: "Home")!
                    ),
                    mapCPListItem(
                        from: favouritesStateMessage.work,
                        title: "favouritesScreenItemTitleWork".localized,
                        image: UIImage(named: "Work")!
                    ),
                ],
                header: "favouritesScreenSectionHomeAndWork".localized,
                sectionIndexTitle: nil
            ),
            CPListSection(
                items: favouritesStateMessage.items.isEmpty
                    ? [emptyItemPlaceHolder]
                    : favouritesStateMessage.items.map(mapCPListItem),
                header: "favouritesScreenSectionFavourites".localized,
                sectionIndexTitle: nil
            ),
        ]
        listTemplate.updateSections(sections)
    }

    private func mapCPListItem(
        from favouriteItemMessage: FavouriteItemMessage?,
        title: String? = nil,
        image: UIImage? = nil
    )
        -> CPListItem
    {
        let item = CPListItem(
            text: title ?? favouriteItemMessage?.title,
            detailText: favouriteItemMessage?.subtitle
                ?? "favouritesScreenItemSubtitlePlaceholder".localized,
            image: image
        )
        item.userInfo = favouriteItemMessage
        item.handler = onItemTap
        return item
    }

    private func mapCPListItem(favouriteItemMessage: FavouriteItemMessage)
        -> CPListItem
    {
        mapCPListItem(from: favouriteItemMessage)
    }

    private func onItemTap(
        listItem: CPSelectableListItem, completion: @escaping () -> Void
    ) {
        if let favouriteItemMessage = listItem.userInfo as? FavouriteItemMessage
        {
            searchNavigation.navigate(
                to: favouriteItemMessage.coordinates.geoPoint,
                destinationName: listItem.text ?? favouriteItemMessage.title,
                additionalInformation: favouriteItemMessage.subtitle
            )
            interfaceController.popToRootTemplate(animated: true) { _, __ in }
        }
        completion()
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }
}
