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
        OBCalendar(drawingRange: .month(1))
    }
    
    var body: some View {
        calendarView
    }
}

#Preview {
    OBCalendarDemo()
}

