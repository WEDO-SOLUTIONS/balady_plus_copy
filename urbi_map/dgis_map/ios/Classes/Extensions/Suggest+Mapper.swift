import Foundation
import DGis

extension Suggest {
    func toMessage(_ index: Int) -> SuggestMessage {
        var type: SuggestHandlerMessage
        switch self.handler {
            case .objectHandler(_):
                type = SuggestHandlerMessage.object
            case .performSearchHandler(_):
                type = SuggestHandlerMessage.search
            case .incompleteTextHandler(_):
                type = SuggestHandlerMessage.incomplete
        }

        return SuggestMessage.make(
            withTitle: self.title.text,
            subTitle: self.subtitle.text,
            index: NSNumber(value: index),
            handler: type
        )
    }
}
