//
//  OBCalendarDemo.swift
//  OBCalendarDemo
//
//  Created by Burak Gül on 18.11.2024.
//

import SwiftUI
import ObiletCalendar

struct OBCalendarDemo: View {
    var calendarView: some View {
        OBCalendar()
            .monthModifier{ baseView, daysView, model in
                VStack {
                    Text("Modified Months")
                    daysView
                }
                .padding()
            }
    }
    
    var body: some View {
        calendarView
    }
}

#Preview {
    OBCalendarDemo()
}

