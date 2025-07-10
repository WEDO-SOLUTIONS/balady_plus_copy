import CarPlay
import Combine
import DGis

class SettingsScreen: NSObject {
    private class Events {
        static let soundOnStateChanged = "soundOnEvent"
    }
    private let userDefaultsPublished: UserDefaultsPublished
    private let trafficControlModel: TrafficControlModel
    private var trafficStateCancellable: DGis.Cancellable?
    private var languageCancellable: Combine.AnyCancellable?
    private var gridTemplate = CPGridTemplate(title: nil, gridButtons: [])
    private var navigationManager: NavigationManager
    private let eventChannel: DgisStreamHandler?
    private let map: Map
    private let traitStyle: UIUserInterfaceStyle
    private let onBackTap: (_: CPBarButton) -> Void
    
    // State variables for save/restore functionality
    private var isTrafficEnabled: Bool = false
    private var isParkingEnabled: Bool = false
    private var isSoundEnabled: Bool = false
    
    init(
        onBackTap: @escaping (_: CPBarButton) -> Void,
        userDefaultsPublished: UserDefaultsPublished,
        eventChannel: DgisStreamHandler?,
        map: Map,
        traitStyle: UIUserInterfaceStyle
    ) {
        self.onBackTap = onBackTap
        self.userDefaultsPublished = userDefaultsPublished
        self.navigationManager = DgisMapInitializer.shared.getNavigationManager()
        self.eventChannel = eventChannel
        self.map = map
        self.traitStyle = traitStyle
        self.trafficControlModel = TrafficControlModel(map: map)
        super.init()
        
        // Restore saved settings
        restoreSettings()
    }
    
    deinit {
        trafficStateCancellable?.cancel()
        languageCancellable?.cancel()
        languageCancellable = nil
    }
    
    // MARK: - Settings Save/Restore
    
    private func restoreSettings() {
        // Restore traffic state
        isTrafficEnabled = userDefaultsPublished.getTrafficEnabled()
        if isTrafficEnabled && !(trafficControlModel.stateChannel.value.status == .enabled || trafficControlModel.stateChannel.value.status == .loading) {
            trafficControlModel.onClicked()
        }
        
        // Restore sound state
        isSoundEnabled = userDefaultsPublished.getSoundEnabled()
        let soundCategories = isSoundEnabled ? DashboardControlModel.allCategories : []
        navigationManager.soundNotificationSettings.enabledSoundCategories = soundCategories
        
        // Restore parking state
        isParkingEnabled = userDefaultsPublished.getParkingEnabled()
        setParkingOn(isParkingEnabled)
    }
    
    func createTemplate() -> CPTemplate {
        let trafficBtn = createTrafficButton()
        let soundBtn = createSoundButton()
        let parkingBtn = createParkingButton()
        
        observeTrafficState()
        
        self.updateTemplate(
            title: NSLocalizedString("settingsScreenTitle", comment: ""),
            gridButtons: [trafficBtn, soundBtn, parkingBtn]
        )
       
        gridTemplate.backButton = CPBarButton(
            title: NSLocalizedString("anyScreenBackButton", comment: ""),
            handler: self.onBackTap
        )
        
        languageCancellable = userDefaultsPublished.$languageString.sink { _ in
            let trafficBtn = self.createTrafficButton()
            let soundBtn = self.createSoundButton()
            let parkingBtn = self.createParkingButton()
            
            self.updateTemplate(
                title: NSLocalizedString("settingsScreenTitle", comment: ""),
                gridButtons: [trafficBtn, soundBtn, parkingBtn]
            )
           
            self.gridTemplate.backButton = CPBarButton(
                title: NSLocalizedString("anyScreenBackButton", comment: ""),
                handler: self.onBackTap
            )
        }
        
        return gridTemplate
    }
    
    func updateTemplate(title: String? = nil, gridButtons: [CPGridButton]? = nil) {
        if #available(iOS 15.0, *) {
            if let title = title {
                gridTemplate.updateTitle(title)
            }
            if let buttons = gridButtons {
                gridTemplate.updateGridButtons(buttons)
            }
        } else {
            gridTemplate = CPGridTemplate(
                title: title ?? gridTemplate.title,
                gridButtons: gridButtons ?? gridTemplate.gridButtons
            )
        }
    }
    
    private func observeTrafficState() {
        trafficStateCancellable = trafficControlModel.stateChannel.sink(
            receiveValue: trafficStateChanged
        )
    }
    
    private func trafficStateChanged(_ state: TrafficControlState) {
        // Update local state based on traffic control model
        isTrafficEnabled = (state.status == .enabled || state.status == .loading)
        
        let newButton = createTrafficButton()
        var updatedButtons = gridTemplate.gridButtons
        if(updatedButtons.count > 0) {
            updatedButtons[0] = newButton
            updateTemplate(gridButtons: updatedButtons)
        }
        
        // Save the updated state
        userDefaultsPublished.saveTrafficEnabled(isTrafficEnabled)
    }
    
    private func createTrafficButton() -> CPGridButton {
        let imageName = isTrafficEnabled ? "SettingsTrafficOn" : "SettingsTrafficOff"
        
        let title = NSLocalizedString("settingsScreenTraffic", comment: "")
        
        let trafficButton = CPGridButton(
            titleVariants: [title],
            image: UIImage(named: imageName)!,
            handler: onTrafficBarTap
        )
        
        return trafficButton
    }
    
    private func onTrafficBarTap(_: CPGridButton) {
        trafficControlModel.onClicked()
        // State will be updated in trafficStateChanged callback
    }
    
    /// - SOUND
    private func createSoundButton() -> CPGridButton {
        let imageName = isSoundEnabled ? "SettingsSoundOn" : "SettingsSoundOff"
        let title = NSLocalizedString("settingsScreenSound", comment: "")
        let button = CPGridButton(
            titleVariants: [title],
            image: UIImage(named: imageName)!,
            handler: toggleSounds
        )
        return button
    }

    func toggleSoundsFromMobile(toggleType: SoundToggleType) {
        // Get new actual value
        let turnOn = toggleType == .all
        
        // Update local state
        isSoundEnabled = turnOn
        
        // Change it on SDK side
        self.navigationManager.soundNotificationSettings.enabledSoundCategories = turnOn ? DashboardControlModel.allCategories : []
        
        // Save the state
        userDefaultsPublished.saveSoundEnabled(isSoundEnabled)
        
        // Change it on CarPlay side
        updateSoundButtonState()
    }
    
    /// Updates the sound button state from external changes (Mobile -> CarPlay)
    func updateSoundButtonState() {
        let newButton = createSoundButton()
        var updatedButtons = gridTemplate.gridButtons
        if(updatedButtons.count > 1) {
            updatedButtons[1] = newButton
            updateTemplate(gridButtons: updatedButtons)
        }
    }
    
    func toggleSounds(_: CPGridButton) {
        // Get new actual value
        isSoundEnabled = !isSoundEnabled
        
        // Change it on SDK side
        self.navigationManager.soundNotificationSettings.enabledSoundCategories = isSoundEnabled ? DashboardControlModel.allCategories : []
        
        // Save the state
        userDefaultsPublished.saveSoundEnabled(isSoundEnabled)
        
        // Change it on Mobile UI side
        self.eventChannel?.success([
            "event": Events.soundOnStateChanged,
            "value": isSoundEnabled
        ])
        
        // Change it on CarPlay side
        updateSoundButtonState()
    }
    
    /// - PARKING
    private func setParkingOn(_ isOn: Bool) {
        var oldValue: Bool?
        if case let .boolean(value) = self.map.attributes.getAttributeValue(name: TrafficAndParkingConstants.parkingAttrName) {
            oldValue = value
        }
        if oldValue != isOn {
            self.map.attributes.setAttributeValue(
                name: TrafficAndParkingConstants.parkingAttrName,
                value: .boolean(isOn)
            )
        }
    }
    
    private func createParkingButton() -> CPGridButton {
        let imageName = isParkingEnabled ? "SettingsParkingOn" : "SettingsParkingOff"
        let title = NSLocalizedString("settingsScreenParking", comment: "")
        let button = CPGridButton(
            titleVariants: [title],
            image: UIImage(named: imageName)!,
            handler: toggleParking
        )
        return button
    }
    
    private func toggleParking(_: CPGridButton) {
        isParkingEnabled = !isParkingEnabled
        
        // Change it on SDK side
        setParkingOn(isParkingEnabled)
        
        // Save the state
        userDefaultsPublished.saveParkingEnabled(isParkingEnabled)
        
        // Change it on CarPlay side
        let newButton = createParkingButton()
        var updatedButtons = gridTemplate.gridButtons
        if(updatedButtons.count > 2) {
            updatedButtons[2] = newButton
            updateTemplate(gridButtons: updatedButtons)
        }
    }
}
