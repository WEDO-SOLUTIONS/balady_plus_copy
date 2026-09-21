//
//  MovingViolationsBundle.swift
//  MovingViolations
//
//  Created by Mahmoud Bahaa on 14/05/1446 AH.
//

import WidgetKit
import SwiftUI

@main
struct MovingViolationsBundle: WidgetBundle {
    var body: some Widget {
        MovingViolations()
        MovingViolationsLiveActivity()
        NavigationLiveActivity()
    }
}
