import CarPlay

class ArrivedNavigationAlert {
    private let mainScreen: MainScreen
    private let navigationSessionManeuvers: NavigationSessionManeuvers

    init(
        mainScreen: MainScreen,
        navigationSessionManeuvers: NavigationSessionManeuvers
    ) {
        self.mainScreen = mainScreen
        self.navigationSessionManeuvers = navigationSessionManeuvers
    }

    func create() -> CPNavigationAlert {
        let endTripTitle = NSLocalizedString(
            "tripFinishedAlertEndTripButton", comment: ""
        )

        let newRouteTitle = NSLocalizedString(
            "tripFinishedAlertNewRouteButton", comment: ""
        )

        let endTripButton =
            if hasFoundColorIssue, #available(iOS 16.0, *) {
                CPAlertAction(
                    title: endTripTitle, color: UIColor(10, 132, 255, 1.0),
                    handler: onEndTripTap
                )
            } else {
                CPAlertAction(
                    title: endTripTitle, style: CPAlertAction.Style.default,
                    handler: onEndTripTap
                )
            }

        let newRouteButton =
            if hasFoundColorIssue, #available(iOS 16.0, *) {
                CPAlertAction(
                    title: newRouteTitle, color: UIColor(192, 218, 243, 1.0),
                    handler: onNewRouteTap
                )
            } else {
                CPAlertAction(
                    title: newRouteTitle, style: CPAlertAction.Style.cancel,
                    handler: onNewRouteTap
                )
            }

        return CPNavigationAlert(
            titleVariants: [
                NSLocalizedString("tripFinishedAlertTitle", comment: "")
            ],
            subtitleVariants: [],
            image: nil,
            primaryAction: endTripButton,
            secondaryAction: newRouteButton,
            duration: TimeInterval(-1)
        )
    }

    func onEndTripTap(_: CPAlertAction) {
        navigationSessionManeuvers.finish()
    }

    func onNewRouteTap(_: CPAlertAction) {
        navigationSessionManeuvers.finish()
        mainScreen.showSearchScreen()
    }
}

// TODO CPAlertAction color behave weirdly, not found straight documentation howto get results as in our design
let hasFoundColorIssue = false
