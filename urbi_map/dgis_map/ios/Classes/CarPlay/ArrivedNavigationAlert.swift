import CarPlay

/// "You arrived" alert on the CarPlay map template.
///
/// BALADY-3795: the alert carries no "End trip" action — ending a trip stays an
/// in-app action (the CarPlay "Finish" bar button, the phone UI). "New route"
/// remains and finishes the trip on its way to the search screen.
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
        let newRouteTitle = NSLocalizedString(
            "tripFinishedAlertNewRouteButton", comment: ""
        )

        let newRouteButton =
            if hasFoundColorIssue, #available(iOS 16.0, *) {
                CPAlertAction(
                    title: newRouteTitle, color: UIColor(192, 218, 243, 1.0),
                    handler: onNewRouteTap
                )
            } else {
                CPAlertAction(
                    title: newRouteTitle, style: CPAlertAction.Style.default,
                    handler: onNewRouteTap
                )
            }

        return CPNavigationAlert(
            titleVariants: [
                NSLocalizedString("tripFinishedAlertTitle", comment: "")
            ],
            subtitleVariants: [],
            image: nil,
            primaryAction: newRouteButton,
            secondaryAction: nil,
            duration: TimeInterval(-1)
        )
    }

    func onNewRouteTap(_: CPAlertAction) {
        navigationSessionManeuvers.finish()
        mainScreen.showSearchScreen()
    }
}

// TODO CPAlertAction color behave weirdly, not found straight documentation howto get results as in our design
let hasFoundColorIssue = false
