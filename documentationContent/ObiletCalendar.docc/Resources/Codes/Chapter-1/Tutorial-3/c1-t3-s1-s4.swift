//
//  OBCalendarDemo.swift
//  OBCalendarDemo
//
//  Created by Burak Gül on 21.11.2024.
//

import SwiftUI
import ObiletCalendar

struct OBCalendarDemo: View {
    var calendar: Calendar
    
    init(calendar: Calendar = Calendar.current) {
        self.calendar = calendar
    }
    
    var body: some View {
        calendarView
    }
    
    var calendarView: some View {
        let today = Date()
        let oneYearsLater = calendar.date(byAdding: .year, value: 1, to: today)!
        return OBBaseCalendar(startDate: today, endDate: oneYearsLater) { model, scrollProxy in
            let day = model.day
            Text("\(day.day)")
        } monthContent: { model, scrollProxy, daysView in
            daysView
        } yearContent: { year, scrollProxy, monthsView in
            monthsView
        }
        
        
    }
}


#Preview {
    var calendar = Calendar.current
    return OBCalendarDemo(calendar: calendar)
}
