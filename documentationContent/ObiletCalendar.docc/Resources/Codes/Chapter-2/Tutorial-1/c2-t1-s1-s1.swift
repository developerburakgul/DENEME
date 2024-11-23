//
//  OBCalendarDemo.swift
//  OBCalendarDemo
//
//  Created by Burak Gül on 18.11.2024.
//

import SwiftUI
import ObiletCalendar

struct OBCalendarDemo: View {
    var calendar: Calendar = Calendar.current
    
    init(_ calendar: Calendar) {
        self.calendar = calendar
    }
    
    var body: some View {
        calendarView
    }
    
    var calendarView: some View {
        OBCalendar(calendar:calendar)
    }
}

#Preview {
    let calendar = Calendar.current
    return OBCalendarDemo(calendar)
}

