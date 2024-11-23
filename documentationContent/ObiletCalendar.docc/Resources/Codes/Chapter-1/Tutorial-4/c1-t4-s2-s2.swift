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
        OBCalendar(includeBlanks:true)
            .dayModifier { baseView, model in
                baseView
                    .background(Color.blue)
                    .padding(2)
                    .foregroundColor(.white)
            }
    }
    
    var body: some View {
        calendarView
    }
}

#Preview {
    OBCalendarDemo()
}

