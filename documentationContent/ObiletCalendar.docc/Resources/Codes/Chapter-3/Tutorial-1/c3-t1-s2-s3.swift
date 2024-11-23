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
    
    var OBRed = Self.makeColor(red: 210, green: 59, blue: 56)
    var OBGray = Self.makeColor(red: 239, green: 239, blue: 239)
    
    var selectedOBBackgroundColor: some View = Circle()
        .foregroundColor(
            Self.makeColor(
                red: 47,
                green: 91,
                blue: 141
            )
        )
    
    @State var firstSelectedDate: Date?
    
    init(_ calendar: Calendar) {
        self.calendar = calendar
    }
    
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            headerView
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(OBRed)
                .foregroundColor(.white)
            
            weekdaysView
                .padding(.vertical,8)
                .padding(.horizontal,16)
                .background(OBGray)
            calendarView
        }
    }
    
    var calendarView: some View {
        OBCalendar(calendar:calendar)
            .dayModifier { baseView, model in
                modifyDayView(model: model.day) {
                    baseView
                }
                .onTapGesture {
                    selectDate(of: model.day)
                }
            }
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
    
    var headerView: some View {
        HStack {
            Text("Departure")
            Spacer()
            Image(systemName: "xmark")
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
    
    private func contentBuilder<Content: View>(@ViewBuilder content: () -> Content) -> Content {
        content()
    }
    
    func modifyDayView<Content:View>(model: CalendarModel.Day, @ViewBuilder content: () -> Content ) -> some View {
        contentBuilder {
            let day = model.day
            let today = calendar.startOfDay(for: Date())
            let dayDate = calendar.startOfDay(for: model.date)
            let modifiedContent = content()
            
            if model.isInRangeCurrentMonth {
                if (dayDate < today) {
                    modifiedContent
                        .foregroundColor(.gray)
                }else {
                    if firstSelectedDate == model.date {
                        modifiedContent
                            .foregroundColor(.white)
                            .background(selectedOBBackgroundColor)
                    }else {
                        modifiedContent
                            .foregroundColor(.black)
                    }
                }
            }else {
                Color.clear
            }
        }
    }
    
    func selectDate(of day: CalendarModel.Day) {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfDay = calendar.startOfDay(for: day.date)
        
        if day.isInRangeCurrentMonth {
            if startOfDay >= startOfToday {
                firstSelectedDate = day.date
            }
        }
        
    }
}

private extension OBCalendarDemo {
    static func makeColor(red: Int, green: Int, blue: Int) -> Color {
        Color(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255
        )
    }
}

#Preview {
    let calendar = Calendar.current
    return OBCalendarDemo(calendar)
}

