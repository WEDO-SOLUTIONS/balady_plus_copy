//
//  AppIntent.swift
//  MovingViolations
//
//  Created by Mahmoud Bahaa on 14/05/1446 AH.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = " "
    static var description = IntentDescription(" ")

    // An example configurable parameter.
    @Parameter(title: "", default: "")
    var balady: String
}
