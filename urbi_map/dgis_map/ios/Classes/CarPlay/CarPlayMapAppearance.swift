import CarPlay

/// Observes the style CarPlay asks for for *map content*.
///
/// CarPlay reports the style of the map separately from the style of the system chrome: with
/// `Appearance = Always Dark` and `Always Show Dark Maps` turned off the bars stay dark while the
/// requested content style is light. The chrome is owned by the head unit and an app cannot
/// override it, but the map is drawn by us, so it has to follow the requested content style —
/// the same thing Apple Maps does.
///
/// `CPSessionConfiguration` is used rather than `CPTemplateApplicationScene.contentStyle` because
/// it is session-wide: the dashboard scene has no content style of its own.
final class CarPlayMapAppearance: NSObject, CPSessionConfigurationDelegate {
    private let onChange: (Bool) -> Void
    private var sessionConfiguration: CPSessionConfiguration?

    /// - Parameter onChange: called on the main thread with `true` when CarPlay asks for a dark
    ///   map, both for the current style and for every later change.
    init(onChange: @escaping (Bool) -> Void) {
        self.onChange = onChange
        super.init()

        let sessionConfiguration = CPSessionConfiguration(delegate: self)
        self.sessionConfiguration = sessionConfiguration
        notify(contentStyle: sessionConfiguration.contentStyle)
    }

    func sessionConfiguration(
        _ sessionConfiguration: CPSessionConfiguration,
        contentStyleChanged contentStyle: CPContentStyle
    ) {
        notify(contentStyle: contentStyle)
    }

    private func notify(contentStyle: CPContentStyle) {
        // An empty set means CarPlay has stated no preference yet — keep whatever the map is
        // showing instead of guessing and flashing the wrong theme at the driver.
        guard !contentStyle.isEmpty else { return }

        onChange(contentStyle.contains(.dark))
    }
}
