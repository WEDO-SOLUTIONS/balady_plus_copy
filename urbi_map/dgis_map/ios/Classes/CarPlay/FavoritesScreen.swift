import CarPlay
import Combine
import DGis

class FavoritesScreen {
    unowned private let listTemplate: CPListTemplate
    private let interfaceController: CPInterfaceController
    private let hostFlutterApi: HostFlutterApi

    init(
        listTemplate: CPListTemplate,
        interfaceController: CPInterfaceController,
        hostFlutterApi: HostFlutterApi
    ) {
        self.listTemplate = listTemplate
        self.interfaceController = interfaceController
        self.hostFlutterApi = hostFlutterApi
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

    private let emptyItemPlaceHolder = CPListItem(
        text: "favouritesScreenPlaceholderEmptyTitle".localized,
        detailText: "favouritesScreenPlaceholderEmptySubtitle".localized
    )

    private func mapCPListItem(
        from favouriteItemMessage: FavouriteItemMessage?,
        title: String? = nil,
        image: UIImage? = nil
    )
        -> CPListItem
    {
        CPListItem(
            text: title ?? favouriteItemMessage?.title,
            detailText: favouriteItemMessage?.subtitle
                ?? "favouritesScreenItemSubtitlePlaceholder".localized,
            image: image
        )
    }

    private func mapCPListItem(favouriteItemMessage: FavouriteItemMessage)
        -> CPListItem
    {
        mapCPListItem(from: favouriteItemMessage)
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }
}
