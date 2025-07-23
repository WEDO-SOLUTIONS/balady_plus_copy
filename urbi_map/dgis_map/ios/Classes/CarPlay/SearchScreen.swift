import CarPlay
import Combine
import DGis

class SearchScreen {
    private let interfaceController: CPInterfaceController
    private let map: Map
    private let userDefaultsPublished: UserDefaultsPublished
    private let searchNavigation: SearchNavigation

    init(
        interfaceController: CPInterfaceController,
        map: Map,
        userDefaultsPublished: UserDefaultsPublished,
        searchNavigation: SearchNavigation
    ) {
        self.interfaceController = interfaceController
        self.map = map
        self.userDefaultsPublished = userDefaultsPublished
        self.searchNavigation = searchNavigation
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        self.searchManager = try! SearchManager.createOnlineManager(
            context: try! sdk.context
        )
        self.searchHistory = SearchHistory(context: try! sdk.context)
    }
    
    deinit {
        languageCancellable?.cancel()
        languageCancellable = nil
    }

    private lazy var gridTemplate = CPGridTemplate(
        title: nil,
        gridButtons: makeGridButtons()
    )

    private let searchManager: SearchManager
    private let searchHistory: SearchHistory
    private let navigationManager = DgisMapInitializer.shared
        .getNavigationManager()
    private var searchTemplateDelegate: KeyboardSearchScreen?
    private var searchDirectoryObjectCancellable: DGis.Cancellable?
    private var languageCancellable: Combine.AnyCancellable?

    func createTemplate() -> CPGridTemplate {
        languageCancellable = userDefaultsPublished.$languageString.sink { _ in
            self.buildViews()
        }
        return gridTemplate
    }

    private func buildViews() {
        gridTemplate.trailingNavigationBarButtons = [
            CPBarButton(
                image: UIImage(named: "Keyboard")!,
                handler: onKeyboardTap
            )
        ]
        
        gridTemplate.backButton = CPBarButton.makeBack(onBackTap)

        if #available(iOS 15, *) {
            gridTemplate.updateGridButtons(makeGridButtons())
        }
    }

    private func onHistoryTap(_: CPGridButton) {
        let screen = HistoryScreen(
            interfaceController: interfaceController,
            searchHistory: searchHistory,
            searchNavigation: searchNavigation,
            userDefaultsPublished: userDefaultsPublished
        )
        screen.createTemplate().show(with: interfaceController)
    }

    private func onQuickFilterTap(_ quickFilter: QuickFilter) {
        let screen = QuickFilterSearchScreen(
            map: map,
            quickFilter: quickFilter,
            searchManager: searchManager,
            searchNavigation: searchNavigation,
            interfaceController: interfaceController,
            userDefaultsPublished: userDefaultsPublished
        )
        screen.createTemplate().show(with: interfaceController)
    }

    private func onKeyboardTap(_: CPBarButton) {
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
    
    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }

    private func makeGridButtons() -> [CPGridButton] {
        var buttons = [
            CPGridButton(
                titleVariants: [
                    NSLocalizedString("searchScreenGridHistory", comment: "")
                ],
                image: UIImage(named: "History")!,
                handler: onHistoryTap
            )
        ]

        for quickFilter in QuickFilter.allCases {
            buttons.append(makeQuickFilterButton(for: quickFilter))
        }

        return buttons
    }

    private func makeQuickFilterButton(for quickFilter: QuickFilter)
        -> CPGridButton
    {
        CPGridButton(
            titleVariants: [
                NSLocalizedString(
                    "quickFilter" + quickFilter.assetKey, comment: ""
                )
            ],
            image: UIImage(named: quickFilter.assetKey)!,
            handler: { [unowned self] _ in self.onQuickFilterTap(quickFilter) }
        )
    }
}

extension QuickFilter {
    fileprivate var assetKey: String {
        rawValue.prefix(1).capitalized + rawValue.dropFirst()
    }
}

protocol SearchNavigation {
    func navigate(to directoryObject: DirectoryObject)
}
