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

    // CarPlay caps a `CPListTemplate` at `maximumItemCount` items and the
    // interface controller's push stack at `maxTemplateStackDepth` templates,
    // unlike the phone app's infinite-scroll results list. We reserve the last
    // slot on each page for a "load more" row that fetches the next `Page` via
    // the SDK's own pagination and pushes it as a fresh `CPListTemplate` with
    // its own reserved slot, so the pattern repeats until either the results
    // or the stack depth run out (BALADY-3682).
    private static let maxTemplateStackDepth = 5

    private var searchCancellable: Cancellable?
    private var nextPageCancellable: Cancellable?
    private weak var listTemplate: CPListTemplate?
    private var currentPage: Page?
    private var hasMoreItems = false
    private var displayedItems: [DirectoryObject] = []

    func createTemplate() -> CPListTemplate {
        let listTemplate = makeListTemplate()

        searchCancellable = searchManager.search(query: buildSearchQuery())
            .sinkOnMainThread { [weak self] searchResult in
                guard let page = searchResult.firstPage else { return }
                self?.showPage(page)
            } failure: { _ in
            }

        return listTemplate
    }

    private func makeListTemplate() -> CPListTemplate {
        let listTemplate = CPListTemplate(title: nil, sections: [])
        listTemplate.backButton = CPBarButton.makeBack(onBackTap)
        self.listTemplate = listTemplate
        return listTemplate
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }

    private func buildSearchQuery() -> SearchQuery {
        let language = Locale.current.languageOrDefault
        let queryText = quickFilter.query[language] ?? ""

        return SearchQueryBuilder.fromQueryText(queryText: queryText)
            .setPageSize(pageSize: Int32(CPListTemplate.maximumItemCount))
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

    private func showPage(_ page: Page) {
        currentPage = page
        displayedItems = page.items
        // Optimistic: we only learn there's no next page once fetchNextPage
        // itself comes back nil/empty/failed.
        hasMoreItems = !page.items.isEmpty
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

            guard let nextPage, !nextPage.items.isEmpty else {
                self.hasMoreItems = false
                self.renderSections()
                return
            }

            self.pushNextPage(nextPage)
        } failure: { [weak self] _ in
            self?.hasMoreItems = false
            self?.renderSections()
            completion()
        }
    }

    // Pushes the next page as its own screen/template so it gets a fresh
    // `maximumItemCount` budget; `nextScreen` is kept alive by its own list
    // items' handler closures once its template is in the CarPlay stack; see
    // `HistoryScreen.show(with:)`/`FavoritesScreen` for the same pattern.
    private func pushNextPage(_ page: Page) {
        let nextScreen = QuickFilterSearchScreen(
            map: map,
            quickFilter: quickFilter,
            searchManager: searchManager,
            searchNavigation: searchNavigation,
            interfaceController: interfaceController
        )
        nextScreen.makeListTemplate().show(with: interfaceController)
        nextScreen.showPage(page)
    }

    private func renderSections() {
        guard let listTemplate else { return }

        let budget = CPListTemplate.maximumItemCount
        let canPushNextPage = interfaceController.templates.count < Self.maxTemplateStackDepth
        let showLoadMore = hasMoreItems && canPushNextPage

        var listItems = displayedItems
            .prefix(showLoadMore ? budget - 1 : budget)
            .map(mapCPListItem)
        if showLoadMore {
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
