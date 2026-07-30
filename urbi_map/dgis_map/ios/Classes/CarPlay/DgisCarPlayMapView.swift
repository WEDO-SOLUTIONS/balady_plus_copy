import Foundation
import MapKit
import CarPlay
import DGis

protocol DgisCarPlayMapViewDelegate {
    func viewDidLoad(with map: Map)
}

class DgisCarPlayMapView: UIViewController {
    static let defaultCameraPositionPoint = CameraPositionPoint(x: 0.5, y: 0.8)
    static let defaultCameraPosition = GeoPoint(latitude: 24.712301, longitude: 46.674175)
    static let defaultCameraZoom = Zoom(value: 17)
    
    private let map: Map
    private let mapView: (UIView & IMapView)
    private let cpWindow: CPWindow
    private lazy var speedControl = createSpeedControlView()
    private lazy var gpsLostBanner = createGpsLostBanner()
    private lazy var gpsLostSpinner = createGpsLostSpinner()
    private lazy var attributionLabel = createAttributionLabel()
    
    private var myLocationControlModel: MyLocationControlModel?
    private var myLocationSource: MyLocationMapObjectSource?
    
    private var cancellables = Set<Cancellable>()
    
    private var mapAppearance: CarPlayMapAppearance?
    private var prefersDarkMapContent = false

    init(
        map: Map,
        mapView: (UIView & IMapView),
        cpWindow: CPWindow
    ) {
        self.map = map
        self.mapView = mapView
        self.cpWindow = cpWindow
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let safeAreaInsets = view.safeAreaInsets
        let frame = view.frame
        let safeAreaRect = CGRect(
            x: safeAreaInsets.left,
            y: safeAreaInsets.top,
            width: frame.width - safeAreaInsets.left - safeAreaInsets.right,
            height: frame.height - safeAreaInsets.top - safeAreaInsets.bottom
        )

        let safeCameraPositionPoint = CameraPositionPoint(
            x: Float(safeAreaRect.midX / frame.maxX),
            y: map.camera.positionPoint.y
        )

        try? map.camera.setPositionPoint(
            positionPoint: safeCameraPositionPoint
        )
        
        speedControl.updateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        
        guard let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }

        try? map.camera.setPositionPoint(positionPoint: Self.defaultCameraPositionPoint)
        
        myLocationControlModel = MyLocationControlModel(map: map)
        
        let myLocationSource = MyLocationMapObjectSource(
            context: context,
            controllerSettings: MyLocationControllerSettings(
                bearingSource: .auto
            ),
            markerType: .model
        )
        self.myLocationSource = myLocationSource
        map.addSource(source: myLocationSource)
        
        if let location = try? sdk.locationService.lastLocation?.coordinates {
            try? map.camera.setPosition(
                point: location.value,
                zoom: Self.defaultCameraZoom
            )
        } else {
            try? map.camera.setPosition(
                point: Self.defaultCameraPosition,
                zoom: Self.defaultCameraZoom
            )
        }
        
        map.attributes.setAttributeValue(name: "camerasOn", value: .boolean(true))

        myLocation()
        
        let pos = map.camera.position
        cancellables.insert(
            map.camera.move(
                point: pos.point,
                zoom: pos.zoom,
                tilt: Tilt(value: 45),
                bearing: pos.bearing
            ).sink(
                receiveValue: { _ in },
                failure: { _ in }
            )
        )
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        view.addSubview(speedControl.view)
        view.addSubview(gpsLostBanner)
        NSLayoutConstraint.activate([
            gpsLostBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            gpsLostBanner.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
        view.addSubview(attributionLabel)
        NSLayoutConstraint.activate([
            attributionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            attributionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
        subscribeToLocationAvailability()
        DgisMapInitializer.shared.getNavigationManager().mapManager.addMap(map: map)
        
        if let styleFactory = try? sdk.styleFactory, let cancellable = map.loadStyle(styleFactory: styleFactory) {
            cancellables.insert(cancellable)
        }

        observeMapAppearance()
    }

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard traitCollection.userInterfaceStyle
                  != previousTraitCollection?.userInterfaceStyle
        else {
            return
        }

        updateAttributionLabel()
    }
    private func updateAttributionLabel() {
        attributionLabel.attributedText = makeAttributionText()
    }

    override func viewDidDisappear(_ animated: Bool) {
        DgisMapInitializer.shared.getNavigationManager().mapManager.removeMap(map: map)
        mapView.subviews.forEach { $0.removeFromSuperview() }
        if let myLocationSource = self.myLocationSource {
            map.removeSource(source: myLocationSource)
            self.myLocationSource = nil
        }
        myLocationControlModel = nil
        cancellables.forEach { $0.cancel() }
        mapAppearance = nil
    }

    private func createAttributionLabel() -> UILabel {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1

        label.attributedText = makeAttributionText()

        return label
    }

    private func makeAttributionText() -> NSAttributedString {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        return NSAttributedString(
            string: "baladyMaps".localized,
            attributes: [
                .strokeColor: isDarkMode ? UIColor.black : UIColor.white,
                .foregroundColor: isDarkMode ? UIColor.white : UIColor.black,
                .strokeWidth: -1,
                .font: UIFont.systemFont(
                    ofSize: 16,
                    weight: .regular
                ),
            ]
        )
    }

    private func createGpsLostSpinner() -> MaterialProgressIndicator {
        let indicator = MaterialProgressIndicator()
        indicator.strokeColor = .white
        indicator.lineWidth = 2.5
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 20),
            indicator.heightAnchor.constraint(equalToConstant: 20),
        ])
        return indicator
    }

    private func createGpsLostBanner() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(red: 0xE0 / 255, green: 0x37 / 255, blue: 0x3D / 255, alpha: 1)
        container.layer.cornerRadius = 12
        container.isHidden = true

        let label = UILabel()
        label.text = "gpsSignalLost".localized
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [gpsLostSpinner, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
        ])
        return container
    }

    private func subscribeToLocationAvailability() {
        let model = DgisMapInitializer.shared.getNavigationManager().uiModel

        func updateBanner() {
            let isLost = !model.locationAvailable
                && model.state != .finished
                && model.state != .disabled
            DispatchQueue.main.async { [weak self] in
                self?.setGpsLostBannerVisible(isLost)
            }
        }

        cancellables.insert(
            model.locationAvailableChannel.sink { _ in updateBanner() }
        )
        cancellables.insert(
            model.stateChannel.sink { _ in updateBanner() }
        )
    }

    private func setGpsLostBannerVisible(_ visible: Bool) {
        guard gpsLostBanner.isHidden == visible else { return }
        gpsLostBanner.isHidden = !visible
        if visible {
            gpsLostSpinner.startAnimating()
        } else {
            gpsLostSpinner.stopAnimating()
        }
    }

    private func createSpeedControlView() -> (
        view: UIView, updateConstraints: () -> Void
    ) {
        let model = DgisMapInitializer.shared.getNavigationManager().uiModel
        let navigationViewFactory =
            (try! DgisMapInitializer.shared.getSdkContainer()
            .makeNavigationViewFactory()).makeNavigationViewControlsFactory()
        let speedControl = navigationViewFactory.makeSpeedControl(
            uiModel: model
        )
        speedControl.translatesAutoresizingMaskIntoConstraints = false

        let orig = 94.0
        let scale = 0.6
        let size = orig * scale
        let shift = (orig - size) / 2
        speedControl.transform = CGAffineTransform(scaleX: scale, y: scale)

        let topConstraint = speedControl.topAnchor.constraint(
            greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
            constant: -shift + 8
        )
        let rightConstraint = speedControl.rightAnchor.constraint(
            equalTo: cpWindow.mapButtonSafeAreaLayoutGuide.rightAnchor,
            constant: shift
        )
        let leftConstraint = speedControl.leftAnchor.constraint(
            equalTo: cpWindow.mapButtonSafeAreaLayoutGuide.leftAnchor,
            constant: -shift
        )

        func updateConstraints() {
            let isLeftWheelCar =
                cpWindow.mapButtonSafeAreaLayoutGuide.layoutFrame.midX
                >= cpWindow.frame.midX
            rightConstraint.isActive = isLeftWheelCar
            leftConstraint.isActive = !isLeftWheelCar
            topConstraint.isActive = true
        }

        return (speedControl, updateConstraints)
    }

    func myLocation() {
        let camera = map.camera
        guard let myLocationControlModel,
              let myLocation = try? DgisMapInitializer.shared.getSdkContainer().locationService.lastLocation?.coordinates else {
            return
        }
        
        let position = camera.position
        if position.zoom.value > Self.defaultCameraZoom.value - 1 {
            myLocationControlModel.onClicked()
            return
        }
        
        let tilt = position.tilt.value > 5 ? position.tilt : Tilt(value: 45)
        
        let navigationManager = DgisMapInitializer.shared.getNavigationManager()
        let navigationState = navigationManager.uiModel.state
        if navigationState == .navigation || navigationState == .routeSearch {
            cancellables.insert(
                camera.move(
                    point: myLocation.value,
                    zoom: Self.defaultCameraZoom,
                    tilt: tilt,
                    bearing: position.bearing
                ).sink(
                    receiveValue: { _ in
                        navigationManager.mapFollowController.setFollow(follow: true)
                    },
                    failure: { _ in }
                )
            )
            return
        }
        
        cancellables.insert(
            camera.move(
                point: myLocation.value,
                zoom: Self.defaultCameraZoom,
                tilt: tilt,
                bearing: position.bearing
            ).sink(
                receiveValue: { _ in },
                failure: { _ in }
            )
        )
        myLocationControlModel.onClicked()
    }

    // MARK: - Day/night appearance

    /// On the car screen the map follows the style CarPlay asks for, not the phone's own
    /// day/night setting, which is what the driver sees in every other CarPlay map.
    private func observeMapAppearance() {
        mapAppearance = CarPlayMapAppearance { [weak self] prefersDark in
            guard let self else { return }

            self.prefersDarkMapContent = prefersDark
            self.applyMapAppearance()
        }
    }

    private func applyMapAppearance() {
        mapView.appearance = prefersDarkMapContent ? .universal("night") : .universal("day")
    }
}

extension UIView {
    func applyTransform(withScale scale: CGFloat, anchorPoint: CGPoint) {
        layer.anchorPoint = anchorPoint
        let scale = scale != 0 ? scale : CGFloat.leastNonzeroMagnitude
        let xPadding = 1/scale * (anchorPoint.x - 0.5)*bounds.width
        let yPadding = 1/scale * (anchorPoint.y - 0.5)*bounds.height
        transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }
}

extension Map {
    func loadStyle(styleFactory: DGis.IStyleFactory) -> DGis.Cancellable? {
        let stylePath = FlutterDartProject.lookupKey(forAsset: "packages/map_styles/src/styles.2gis")
        guard let assetPath = Bundle.main.path(forResource: stylePath, ofType: nil) else { return nil }
        return styleFactory.loadFile(path: assetPath).sink(
            receiveValue: { style in
                self.style = style
                self.attributes.setAttributeValue(name: "split_screen_on", value: .boolean(true))
            },
            failure: { _ in }
        )
    }
}

class MaterialProgressIndicator: UIView {
    
    private let progressLayer = CAShapeLayer()
    private var isAnimating = false

    // Appearance settings
    var strokeColor: UIColor = .systemBlue {
        didSet { progressLayer.strokeColor = strokeColor.cgColor }
    }
    
    var lineWidth: CGFloat = 4.0 {
        didSet { progressLayer.lineWidth = lineWidth; updatePath() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        updatePath()
    }
    
    private func setupLayer() {
        progressLayer.strokeColor = strokeColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round // Rounded line caps as in Material 3
        layer.addSublayer(progressLayer)
    }
    
    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - (lineWidth / 2)
        
        // Start point at the top (-90 degrees)
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: -.pi / 2,
                                endAngle: .pi * 1.5,
                                clockwise: true)
        progressLayer.path = path.cgPath
    }
    
    // CoreAnimation removes animations when the view leaves the window — restart them on return
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil && isAnimating {
            addAnimations()
        }
    }

    // Start the signature Material animation
    func startAnimating() {
        isAnimating = true
        addAnimations()
    }

    private func addAnimations() {
        guard progressLayer.animation(forKey: "rotation") == nil else { return }

        // 1. The head of the arc runs ahead, the tail catches up with a delay — the arc grows,
        // then collapses into a point. The cycle starts and ends with a zero-length arc,
        // so the transition between repeats is seamless.
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = 0.75
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeEndAnimation.fillMode = .forwards

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.beginTime = 0.5
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.duration = 0.75
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeStartAnimation.fillMode = .backwards

        let strokeGroup = CAAnimationGroup()
        strokeGroup.animations = [strokeEndAnimation, strokeStartAnimation]
        strokeGroup.duration = 1.25
        strokeGroup.repeatCount = .infinity

        // 2. Continuous rotation of the layer itself
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1.5 // Full-rotation speed
        rotationAnimation.repeatCount = .infinity

        progressLayer.add(strokeGroup, forKey: "strokeAndCollapse")
        progressLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    // Stop the animation
    func stopAnimating() {
        isAnimating = false
        progressLayer.removeAllAnimations()
    }
}
