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
    }
    
    var body: some View {
        calendarView
    }
}

#Preview {
    OBCalendarDemo()
}
