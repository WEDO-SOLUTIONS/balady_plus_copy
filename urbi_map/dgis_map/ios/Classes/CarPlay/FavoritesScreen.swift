import CarPlay
import Combine
import DGis

class FavoritesScreen {
    unowned private let listTemplate: CPListTemplate
    private let interfaceController: CPInterfaceController
    private let hostFlutterApi: HostFlutterApi
    private let searchNavigation: SearchNavigation
    private let trafficRouter: TrafficRouter
    private let locationService: LocationService

    init(
        listTemplate: CPListTemplate,
        interfaceController: CPInterfaceController,
        hostFlutterApi: HostFlutterApi,
        searchNavigation: SearchNavigation,
        trafficRouter: TrafficRouter,
        locationService: LocationService
    ) {
        self.listTemplate = listTemplate
        self.interfaceController = interfaceController
        self.hostFlutterApi = hostFlutterApi
        self.searchNavigation = searchNavigation
        self.trafficRouter = trafficRouter
        self.locationService = locationService
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
            Task {
                showFavorites(
                    favouritesStateMessage,
                    await findHomeWorkBriefRouteInfo(favouritesStateMessage)
                )
            }
        case .failure(let error):
            self.listTemplate.emptyViewTitleVariants = [
                String(describing: error)
            ]
        }
    }

    private func findHomeWorkBriefRouteInfo(
        _ favouritesStateMessage: FavouritesStateMessage
    ) async -> HomeWorkBriefRouteInfo {
        let none: HomeWorkBriefRouteInfo = (home: nil, work: nil)

        guard let lastLocation = locationService.lastLocation else {
            return none
        }

        let homeWorkGeoPoints = [
            favouritesStateMessage.home?.coordinates.geoPoint,
            favouritesStateMessage.work?.coordinates.geoPoint,
        ]

        let searchPoints = homeWorkGeoPoints.compactMap { $0 }.map {
            geoPoint in
            let startSearchPoint = RouteSearchPoint(
                coordinates: lastLocation.coordinates.value
            )
            let endSearchPoint = RouteSearchPoint(coordinates: geoPoint)
            return BriefRouteInfoSearchPoints(
                startPoint: startSearchPoint, finishPoint: endSearchPoint
            )
        }

        let future = trafficRouter.findBriefRouteInfos(
            searchPoints: searchPoints,
            routeSearchOptions: RouteSearchOptions.car(
                CarRouteSearchOptions()
            )
        )

        guard
            let briefRouteInfos = try? await future.asAsync(),
            !briefRouteInfos.isEmpty
        else { return none }

        if briefRouteInfos.count == 2 {
            return (home: briefRouteInfos[0], work: briefRouteInfos[1])
        }

        if favouritesStateMessage.home != nil {
            return (home: briefRouteInfos[0], work: nil)
        }

        if favouritesStateMessage.work != nil {
            return (home: nil, work: briefRouteInfos[0])
        }

        return none
    }

    private func formatBriefRouteInfo(_ briefRouteInfo: BriefRouteInfo)
        -> String
    {
        let millimeters =
            switch briefRouteInfo.extraInfo {
            case .car(let car):
                car.length.millimeters
            default:
                Int64(0)
            }

        let distanceMeasurement = Measurement<UnitLength>(
            value: Double(millimeters), unit: .millimeters
        )

        let delimiter = " • "

        return briefRouteInfo.duration.minutesWithinHourOrHoursAndMinutes()
            + delimiter + distanceMeasurement.formatMeters.formatWithComma()
            + delimiter
    }

    private func showFavorites(
        _ favouritesStateMessage: FavouritesStateMessage,
        _ homeWorkBriefRouteInfo: HomeWorkBriefRouteInfo
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
                        briefRouteInfo: homeWorkBriefRouteInfo.home,
                        title: "favouritesScreenItemTitleHome".localized,
                        image: UIImage(named: "Home")!
                    ),
                    mapCPListItem(
                        from: favouritesStateMessage.work,
                        briefRouteInfo: homeWorkBriefRouteInfo.work,
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
        briefRouteInfo: BriefRouteInfo? = nil,
        title: String? = nil,
        image: UIImage? = nil
    )
        -> CPListItem
    {
        let estimates =
            if let briefRouteInfo = briefRouteInfo {
                formatBriefRouteInfo(briefRouteInfo)
            } else {
                ""
            }

        let title = title ?? favouriteItemMessage?.title ?? ""

        let item = CPListItem(
            text: estimates + title,
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

private typealias HomeWorkBriefRouteInfo = (
    home: BriefRouteInfo?, work: BriefRouteInfo?
)
