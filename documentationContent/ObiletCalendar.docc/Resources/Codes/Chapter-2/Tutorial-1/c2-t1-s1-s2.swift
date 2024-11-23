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
        VStack {
            weekdaysView
                .padding()
            calendarView
        }
    }
    
    var calendarView: some View {
        OBCalendar(calendar:calendar)
    }
    
    var weekdaysView: some View {
        let weekdays = getShortLocalizedWeekdays(for: calendar)
        return HStack {
            ForEach(weekdays.indices, id: \.self) { index in
                Text(weekdays[index])
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    func getShortLocalizedWeekdays(
        for calendar: Calendar
    ) -> [String] {
        let firstWeekday = calendar.firstWeekday
        let shortWeekdays = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = firstWeekday - 1
        let reorderedShortWeekdays = Array(shortWeekdays[firstWeekdayIndex...])
        + Array(shortWeekdays[..<firstWeekdayIndex])
        return reorderedShortWeekdays
    }
}

#Preview {
    let calendar = Calendar.current
    return OBCalendarDemo(calendar)
}

