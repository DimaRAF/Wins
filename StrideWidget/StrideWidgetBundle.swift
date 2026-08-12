//
//  StrideWidgetBundle.swift
//  StrideWidget
//
//  Created by Raghad Alkhurayyif on 28/02/1448 AH.
//

import WidgetKit
import SwiftUI

@main
struct StrideWidgetBundle: WidgetBundle {
    var body: some Widget {
        StrideWidget()
        StrideWidgetControl()
        StrideWidgetLiveActivity()
    }
}
