import CarPlay

extension CPBarButton {
    static func makeBack(_ handler: CPBarButtonHandler?) -> CPBarButton {
        CPBarButton(
            title: NSLocalizedString("anyScreenBackButton", comment: ""),
            handler: handler
        )
    }
}
