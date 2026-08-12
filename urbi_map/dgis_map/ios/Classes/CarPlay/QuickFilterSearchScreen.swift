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
    private var nextPageCancellable: Cancellable?
    private weak var listTemplate: CPListTemplate?
    private var currentPage: Page?
    private var requestedPageSize: Int32 = 0
    private var hasMoreItems = false
    private var displayedItems: [DirectoryObject] = []

    func createTemplate() -> CPListTemplate {
        let listTemplate = CPListTemplate(title: nil, sections: [])

        listTemplate.backButton = CPBarButton.makeBack(onBackTap)
        self.listTemplate = listTemplate

        searchCancellable = searchManager.search(query: buildSearchQuery())
            .sinkOnMainThread { [weak self] searchResult in
                self?.showSearchResult(searchResult)
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
        requestedPageSize = pageSize

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

    // CarPlay's `CPListTemplate`/`CPSearchTemplate` can only render one page of
    // results at a time (`CPListTemplate.maximumItemCount`), unlike the phone
    // app's infinite-scroll results list. We surface a trailing "load more" row
    // that fetches the next `Page` via the SDK's own pagination (BALADY-3682).
    private func showSearchResult(_ searchResult: SearchResult) {
        guard let page = searchResult.firstPage else { return }
        currentPage = page
        displayedItems = page.items
        hasMoreItems = page.items.count >= Int(requestedPageSize)
        renderSections()
    }

    private func loadMoreTapped(
        listItem: CPSelectableListItem, completion: @escaping () -> Void
    ) {
        guard let currentPage else {
            completion()
            return
        }

        nextPageCancellable = currentPage.fetchNextPage().sinkOnMainThread {
            [weak self] nextPage in
            defer { completion() }
            guard let self else { return }

            guard let nextPage else {
                self.hasMoreItems = false
                self.renderSections()
                return
            }

            self.currentPage = nextPage
            self.displayedItems.append(contentsOf: nextPage.items)
            self.hasMoreItems = nextPage.items.count >= Int(self.requestedPageSize)
            self.renderSections()
        } failure: { [weak self] _ in
            self?.hasMoreItems = false
            self?.renderSections()
            completion()
        }
    }

    private func renderSections() {
        guard let listTemplate else { return }

        let budget = CPListTemplate.maximumItemCount
        var listItems = displayedItems.map(mapCPListItem)
        if listItems.count > budget {
            listItems = Array(listItems.prefix(budget))
        } else if hasMoreItems && listItems.count < budget {
            listItems.append(makeLoadMoreItem())
        }

        listTemplate.updateSections([CPListSection(items: listItems)])
    }

    private func makeLoadMoreItem() -> CPListItem {
        let item = CPListItem(
            text: NSLocalizedString(
                "quickFilterSearchScreenLoadMoreTitle", comment: ""
            ),
            detailText: nil
        )
        item.handler = loadMoreTapped
        return item
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
