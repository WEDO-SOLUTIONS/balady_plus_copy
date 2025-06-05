import CarPlay
import DGis

class KeyboardSearchScreen: NSObject, CPSearchTemplateDelegate {
    private let interfaceController: CPInterfaceController
    private let map: Map
    private let searchManager: SearchManager
    private let searchHistory: SearchHistory
    private let searchNavigation: SearchNavigation

    init(
        interfaceController: CPInterfaceController,
        searchManager: SearchManager,
        searchHistory: SearchHistory,
        searchNavigation: SearchNavigation,
        map: Map
    ) {
        self.interfaceController = interfaceController
        self.map = map
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        self.searchManager = searchManager
        self.searchHistory = searchHistory
        self.searchHandler = SearchHandler(
            searchManager: searchManager,
            map: map,
            sdkContext: sdk
        )
        self.searchNavigation = searchNavigation
    }

    private let searchHandler: SearchHandler

    func searchTemplate(
        _ searchTemplate: CPSearchTemplate,
        updatedSearchText searchText: String
    ) async -> [CPListItem] {
        if (searchText.isEmpty) {
            var cancellable: Cancellable?

            let items = await withUnsafeContinuation { continuation in
                cancellable = searchHistory.items(
                    page: SearchHistoryPage()
                ).sink(receiveValue: {
                    result in
                    let listItems = result.items.map(self.mapCPListItem)
                    continuation.resume(returning: listItems)
                }) { _ in continuation.resume(returning: [CPListItem]()) }
            }

            cancellable?.cancel()

            return items
        }

        let items = await withUnsafeContinuation { continuation in
            searchHandler.fetchSuggests(
                queryText: searchText,
                allowedResultTypes: [],
                searchGeoRect: nil,
                locale: nil,
                suggestorType: SuggestorTypeEnum.routeEndpoint,
                limit: nil
            ) { result in
                switch result {
                case .success(let value):
                    let cpListItems = value.suggests.map(
                        self.createSuggestMessageCPListItem
                    )
                    continuation.resume(returning: cpListItems)
                case .failure(let error):
                    continuation.resume(returning: [])
                }
            }
        }
        return items
    }

    private func mapCPListItem(searchHistoryItem: SearchHistoryItem)
        -> CPListItem
    {
        let listItem =
            switch searchHistoryItem {
            case .directoryObject(let directoryObject):
                CPListItem(
                    text: directoryObject.title,
                    detailText: directoryObject.subtitle
                )
            case .searchQuery(let searchQuery):
                CPListItem(
                    text: searchQuery.title,
                    detailText: searchQuery.subtitle
                )
            @unknown default:
                fatalError("unknown SearchHistoryItem")
            }
        listItem.userInfo = searchHistoryItem
        return listItem
    }

    func onHistoryTap(searchHistoryItem: SearchHistoryItem) {
        switch searchHistoryItem {
        case .directoryObject(let directoryObject):
            searchNavigation.navigate(to: directoryObject)
        case .searchQuery(_):
            break
        @unknown default:
            break
        }
        interfaceController.popToRootTemplate(animated: true) { _, __ in }
    }

    private func createSuggestMessageCPListItem(suggestMessage: SuggestMessage)
        -> CPListItem
    {
        let item = CPListItem(
            text: suggestMessage.title.text,
            detailText: suggestMessage.subtitle.text
        )
        item.userInfo = suggestMessage
        return item
    }

    func searchTemplate(
        _ searchTemplate: CPSearchTemplate, selectedResult item: CPListItem
    ) async {
        let userInfo = item.userInfo

        if userInfo is SearchHistoryItem {
            onHistoryTap(searchHistoryItem: userInfo as! SearchHistoryItem)
            return
        }

        let suggestMessage = item.userInfo as! SuggestMessage

        guard
            let dgisObjectId = suggestMessage.handler.objectHandler?.item.id?
                .toDgisObjectId()
        else {
            return
        }

        var cancellable: Cancellable?

        let directoryObject = try! await withCheckedThrowingContinuation {
            continuation in
            cancellable = searchManager.searchByDirectoryObjectId(
                objectId: dgisObjectId
            ).sink(
                receiveValue: {
                    directoryObject in
                    continuation.resume(returning: directoryObject)
                },
                failure: {
                    _ in
                    continuation.resume(returning: nil)
                }
            )
        }

        cancellable?.cancel()

        onFoundTap(directoryObject: directoryObject)
    }

    func onFoundTap(directoryObject: DirectoryObject?) {
        interfaceController.popToRootTemplate(animated: true) { _, __ in }
        guard let directoryObject = directoryObject else { return }
        saveHistory(directoryObject: directoryObject)
        searchNavigation.navigate(to: directoryObject)
    }

    private func saveHistory(directoryObject: DirectoryObject) {
        searchHistory.addItem(
            item: SearchHistoryItem.directoryObject(directoryObject)
        )
    }
}
