import Foundation
import DGis

/// Creates new road events via the native RoadEventManager. Lanes are only
/// forwarded to the SDK for event types whose create* overload accepts them
/// (accident/roadWorks/other) — camera/roadRestriction/comment have no lanes
/// parameter natively, so `lanes` is simply not passed for those.
class RoadEventReportHandler {
    private let roadEventManager: RoadEventManager
    private var cancelable: Array<Cancellable> = []

    init(sdk: Context) {
        self.roadEventManager = RoadEventManager(context: sdk)
    }

    func createRoadEvent(
        type: RoadEventTypeMessage,
        location: GeoPointMessage,
        lanes: [RoadEventLaneMessage],
        description: String,
        completion: @escaping (Result<AddRoadEventResultMessage, any Error>) -> Void
    ) {
        let point = location.geoPoint
        let laneOptionSet = lanes.toLaneOptionSet()
        let future: Future<AddEventResult>
        switch type {
        case .accident:
            future = self.roadEventManager.createAccident(location: point, lanes: laneOptionSet, description: description)
        case .roadWorks:
            future = self.roadEventManager.createRoadWorks(location: point, lanes: laneOptionSet, description: description)
        case .other:
            future = self.roadEventManager.createOther(location: point, lanes: laneOptionSet, description: description)
        case .camera:
            future = self.roadEventManager.createCamera(location: point, description: description)
        case .roadRestriction:
            future = self.roadEventManager.createRoadRestriction(location: point, description: description)
        case .comment:
            future = self.roadEventManager.createComment(location: point, description: description)
        }

        self.cancelable.append(
            future.sink(receiveValue: { result in
                switch result {
                case .event:
                    completion(.success(.ok))
                case .error(let error):
                    completion(.success(error.toMessage()))
                }
            }, failure: { error in
                completion(.failure(FlutterError(
                    code: "ROAD_EVENT_CREATE_ERROR",
                    message: error.description,
                    details: nil
                )))
            })
        )
    }
}
