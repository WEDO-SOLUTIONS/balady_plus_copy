import CarPlay
import DGis

extension CPTemplate {
    func show(with interfaceController: CPInterfaceController) {
        interfaceController.pushTemplate(
            self,
            animated: true,
            completion: nil
        )
    }
}

class HistoryScreen: NSObject, CPSessionConfigurationDelegate {
    private let interfaceController: CPInterfaceController
    private let searchHistory: SearchHistory
    private let searchNavigation: SearchNavigation
    private let searchManager: SearchManager
    private let map: Map
    private var searchTemplateDelegate: KeyboardSearchScreen?

    init(
        interfaceController: CPInterfaceController,
        searchHistory: SearchHistory,
        searchNavigation: SearchNavigation,
        searchManager: SearchManager,
        map: Map
    ) {
        self.interfaceController = interfaceController
        self.searchHistory = searchHistory
        self.searchNavigation = searchNavigation
        self.searchManager = searchManager
        self.map = map
    }

    private let listTemplate = CPListTemplate(title: nil, sections: [])
    private var searchHistoryCancellable: DGis.Cancellable?
    private var showEmptyPlaceHolder = false

    func createTemplate() -> CPListTemplate {
        loadHistory()
        
        buildViews()

        return listTemplate
    }

    private func buildViews() {
        let key =
            showEmptyPlaceHolder
            ? "historyScreenSearchBackButton" : "anyScreenBackButton"
        listTemplate.backButton = CPBarButton(
            title: NSLocalizedString(key, comment: ""),
            handler: onBackTap
        )
    }

    private func loadHistory() {
        let itemsFuture = searchHistory.items(page: SearchHistoryPage())
        self.searchHistoryCancellable?.cancel()
        self.searchHistoryCancellable = itemsFuture.sinkOnMainThread(
            receiveValue: whenLoaded
        ) { _ in

        }
    }

    private func whenLoaded(result: SearchHistoryResult) {
        showEmptyPlaceHolder = result.items.isEmpty
        if showEmptyPlaceHolder {
            buildViews()
             let placeholderItem = CPListItem(
                        text: NSLocalizedString("historyScreenEmptyPlaceholderTitle", comment: ""),
                        detailText: NSLocalizedString("historyScreenEmptyPlaceholderSubtitleTitle", comment: "")
                    )
                    let section = CPListSection(items: [placeholderItem])
                    listTemplate.updateSections([section])
            return
        }
        let listItems = result.items.map(mapCPListItem)
        let section = CPListSection(items: listItems)
        listTemplate.updateSections([section])
    }

    private func mapCPListItem(searchHistoryItem: SearchHistoryItem)
        -> CPListItem
    {
        let listItem =
            switch searchHistoryItem {
            case .directoryObject(let directoryObject):
                CPListItem(
                    text: directoryObject.title,
                    detailText: directoryObject.addressString
                )
            case .searchQuery(let searchQuery):
                CPListItem(
                    text: searchQuery.title,
                    detailText: searchQuery.subtitle
                )
            @unknown default:
                fatalError("unknown SearchHistoryItem")
            }
        listItem.handler = onItemTap
        listItem.userInfo = searchHistoryItem
        return listItem
    }

    private func onItemTap(
        listItem: CPSelectableListItem, completion: @escaping () -> Void
    ) {
        let searchHistoryItem = listItem.userInfo as! SearchHistoryItem

        switch searchHistoryItem {
        case .directoryObject(let directoryObject):
            searchNavigation.navigate(to: directoryObject)
            interfaceController.popToRootTemplate(animated: true) { _, __ in }
        case .searchQuery(_):
            openKeyboardSearchScreen();
            break
        @unknown default:
            break
        }
        completion()
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }
    
    private func openKeyboardSearchScreen() {
        self.searchTemplateDelegate = KeyboardSearchScreen(
            interfaceController: interfaceController,
            searchManager: searchManager,
            searchHistory: searchHistory,
            searchNavigation: searchNavigation,
            map: map
        )
        let searchTemplate = CPSearchTemplate()
        searchTemplate.delegate = self.searchTemplateDelegate
        interfaceController.pushTemplate(searchTemplate, animated: true) {
            _, __ in
        }
    }
}
