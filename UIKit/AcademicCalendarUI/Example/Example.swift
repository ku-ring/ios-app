//
//  Example.swift
//  AcademicCalendarUI
//
//  Created by Jung Hwan Park on 11/26/25.
//

import SwiftUI
import AcademicCalendarUI
import AcademicCalendarFeatures

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            AcademicCalendar(store: .init(initialState: AcademicCalendarFeature.State(), reducer: {
                AcademicCalendarFeature()._printChanges()
            }))
        }
    }
}

