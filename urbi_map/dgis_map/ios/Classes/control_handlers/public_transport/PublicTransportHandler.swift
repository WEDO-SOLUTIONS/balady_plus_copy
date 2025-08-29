import DGis
import Foundation

class PublicTransportHandler {
    private class Events {
        static let onPublicTransportRoutesChanged = "onPublicTransportRoutesChanged"
        static let onPublicTransportActiveRouteChanged = "onPublicTransportActiveRouteChanged"
    }
    
    private let eventChannel: DgisStreamHandler
    private let routeHandler: RouteHandler
    
    init(eventChannel: DgisStreamHandler, routeHandler: RouteHandler) {
        self.eventChannel = eventChannel
        self.routeHandler = routeHandler
    }

    func onRoutesChanged() {        
        let trafficRoutes = routeHandler.getPublicTransportRoutes()
        
        let briefs = trafficRoutes.map { BriefPublicTransportModel(route: $0) }

        eventChannel.success([
            "event": Events.onPublicTransportRoutesChanged,
            "routes": briefs.map { $0.toMap() },
        ])
    }

    func onActiveRouteChanged() {
        guard let activeRoute = routeHandler.getActivePublicTransportRoute() else {
            return
        }
        
        eventChannel.success([
            "event": Events.onPublicTransportActiveRouteChanged,
            "route": PublicTransportModel(route: activeRoute).toMap(),
        ])
    }
}

