import CarPlay
import Combine
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
    private let userDefaultsPublished: UserDefaultsPublished

    init(
        interfaceController: CPInterfaceController,
        searchHistory: SearchHistory,
        searchNavigation: SearchNavigation,
        userDefaultsPublished: UserDefaultsPublished
    ) {
        self.interfaceController = interfaceController
        self.searchHistory = searchHistory
        self.searchNavigation = searchNavigation
        self.userDefaultsPublished = userDefaultsPublished
    }

    deinit {
        languageCancellable?.cancel()
        languageCancellable = nil
    }

    private let listTemplate = CPListTemplate(title: nil, sections: [])
    private var searchHistoryCancellable: DGis.Cancellable?
    private var languageCancellable: Combine.AnyCancellable?
    private var showEmptyPlaceHolder = false

    func createTemplate() -> CPListTemplate {
        loadHistory()

        languageCancellable = userDefaultsPublished.$languageString.sink { _ in
            self.buildViews()
        }

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

        if showEmptyPlaceHolder {
            listTemplate.emptyViewTitleVariants = [
                NSLocalizedString(
                    "historyScreenEmptyPlaceholderTitle",
                    comment: ""
                )
            ]
        }
    }

    private func loadHistory() {
        let itemsFuture = searchHistory.items(page: SearchHistoryPage())
        self.searchHistoryCancellable?.cancel()
        self.searchHistoryCancellable = itemsFuture.sink(
            receiveValue: whenLoaded
        ) { _ in

        }
    }

    private func whenLoaded(result: SearchHistoryResult) {
        showEmptyPlaceHolder = result.items.isEmpty
        if showEmptyPlaceHolder {
            buildViews()
            return
        }
        let listItems = result.items.map(mapCPListItem)
        let section = CPListSection(items: listItems)
        listTemplate.updateSections([section])
    }

    private func addressToString(_ address: Address?) -> String {
        guard let address = address else { return "" }

        let delimiter = ", "

        let addressComponents = address.components.reduce("") {
            partial, addressComponent in
            let componentString =
                switch addressComponent {
                case .streetAddress(let addressStreet):
                    addressStreet.number + delimiter + addressStreet.street
                case .number(let number):
                    number.number
                case .location(let location):
                    location.comment
                @unknown default:
                    ""
                }
            return partial + componentString + delimiter
        }

        let drillDownTypes: Set = ["city", "district"]

        let drillDown = address.drillDown.filter {
            addressAdmDiv in drillDownTypes.contains(addressAdmDiv.type)
        }.reduce("") {
            partial, addressAdmDiv in partial + addressAdmDiv.name + delimiter
        }

        let result = addressComponents + drillDown

        return result.hasSuffix(delimiter)
            ? String(result.dropLast(delimiter.count)) : result
    }

    private func mapCPListItem(searchHistoryItem: SearchHistoryItem)
        -> CPListItem
    {
        let listItem =
            switch searchHistoryItem {
            case .directoryObject(let directoryObject):
                CPListItem(
                    text: directoryObject.title,
                    detailText: addressToString(directoryObject.address)
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
        case .searchQuery(_):
            break
        @unknown default:
            break
        }
        completion()
        interfaceController.popToRootTemplate(animated: true) { _, __ in }
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }
}
