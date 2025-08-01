import CarPlay
import DGis
import Foundation

class QuickFilterSearchScreen {
    private let map: Map
    private let quickFilter: QuickFilter
    private let searchManager: SearchManager
    private let searchNavigation: SearchNavigation
    private let interfaceController: CPInterfaceController

    init(
        map: Map,
        quickFilter: QuickFilter,
        searchManager: SearchManager,
        searchNavigation: SearchNavigation,
        interfaceController: CPInterfaceController
    ) {
        self.map = map
        self.quickFilter = quickFilter
        self.searchManager = searchManager
        self.searchNavigation = searchNavigation
        self.interfaceController = interfaceController
    }

    private var searchCancellable: Cancellable?

    func createTemplate() -> CPListTemplate {
        let listTemplate = CPListTemplate(title: nil, sections: [])

        listTemplate.backButton = CPBarButton.makeBack(onBackTap)

        searchCancellable = searchManager.search(query: buildSearchQuery())
            .sinkOnMainThread { [weak self] searchResult in
                self?.showSearchResult(searchResult, on: listTemplate)
            } failure: { _ in
            }

        return listTemplate
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }

    private func buildSearchQuery() -> SearchQuery {
        let language = Locale.current.languageOrDefault
        let queryText = quickFilter.query[language] ?? ""

        let pageSize = Int32(CPListTemplate.maximumItemCount)

        return SearchQueryBuilder.fromQueryText(queryText: queryText)
            .setPageSize(pageSize: pageSize)
            .setLocale(
                locale: Locale.makeLocale(localeStr: language.identifier)
            )
            .setSortingType(sortingType: .byRelevance)
            .setAreaOfInterest(rect: map.camera.visibleRect)
            .setSpatialRestriction(
                spatialRestriction: SearchHandler.saRestrictions
            )
            .build()
    }

    private func showSearchResult(
        _ searchResult: SearchResult, on listTemplate: CPListTemplate
    ) {
        guard let items = searchResult.firstPage?.items else { return }
        let listItems = items.map(mapCPListItem)
        let section = CPListSection(items: listItems)
        listTemplate.updateSections([section])
    }

    private func mapCPListItem(directoryObject: DirectoryObject) -> CPListItem {
        let item = CPListItem(
            text: directoryObject.title,
            detailText: directoryObject.addressString
        )
        item.userInfo = directoryObject
        item.handler = onItemTap
        return item
    }

    private func onItemTap(
        listItem: CPSelectableListItem, completion: @escaping () -> Void
    ) {
        let directoryObject = listItem.userInfo as! DirectoryObject
        completion()
        searchNavigation.navigate(to: directoryObject)
        interfaceController.popToRootTemplate(animated: true) { _, __ in }
    }
}

// Copy paste of mapness/lib/entities/quick_filters/quick_filter.dart:8
enum QuickFilter: String, CaseIterable {
    case eatOut, mosques, markets, hotels, fuel

    // Copy paste of mapness/lib/entities/quick_filters/quick_filter.dart:63
    fileprivate var query: [Language: String] {
        switch self {
        case .mosques:
            [
                Language.en: "Mosques",
                Language.ar: "المساجد",
            ]
        case .fuel:
            [
                Language.en: "Fuel",
                Language.ar: "وقود",
            ]
        case .hotels:
            [
                Language.en: "Hotels",
                Language.ar: "فنادق",
            ]
        case .markets:
            [
                Language.en: "Market",
                Language.ar: "سوق",
            ]
        case .eatOut:
            [
                Language.en: "Eat out",
                Language.ar: "مطاعم",
            ]
        }
    }
}
