//
//  MovingViolationsLiveActivity.swift
//  MovingViolations
//
//  Created by Mahmoud Bahaa on 14/05/1446 AH.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MovingViolationsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MovingViolationsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MovingViolationsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MovingViolationsAttributes {
    fileprivate static var preview: MovingViolationsAttributes {
        MovingViolationsAttributes(name: "World")
    }
}

extension MovingViolationsAttributes.ContentState {
    fileprivate static var smiley: MovingViolationsAttributes.ContentState {
        MovingViolationsAttributes.ContentState(emoji: "")
     }
     
     fileprivate static var starEyes: MovingViolationsAttributes.ContentState {
         MovingViolationsAttributes.ContentState(emoji: "")
     }
}

#Preview("Notification", as: .content, using: MovingViolationsAttributes.preview) {
   MovingViolationsLiveActivity()
} contentStates: {
    MovingViolationsAttributes.ContentState.smiley
    MovingViolationsAttributes.ContentState.starEyes
}
