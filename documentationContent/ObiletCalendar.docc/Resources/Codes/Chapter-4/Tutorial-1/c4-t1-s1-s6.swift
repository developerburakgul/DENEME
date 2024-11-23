//
//  OBCalendarWithSpecialDay.swift
//  OBCalendarWithSpecialDay
//
//  Created by Burak Gül on 19.11.2024.
//

import SwiftUI
import ObiletCalendar

struct OBCalendarWithSpecialDay: View {
    var calendar: Calendar = Calendar.current
    let specialDays: [Date?: String]
    
    var OBRed = Self.makeColor(red: 210, green: 59, blue: 56)
    var OBGray = Self.makeColor(red: 239, green: 239, blue: 239)
    var OBBlue = Self.makeColor(red: 47, green: 91, blue: 141)
    
    init(_ calendar: Calendar) {
        self.calendar = calendar
        self.specialDays = Self.makeSpecialDays(calendar: calendar)
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
                let modifiedContent = modifyDayView(model: model.day){
                    baseView
                }
                
                modifySpecialDayView(model: model.day) {
                    modifiedContent
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
            
            if model.isInRangeCurrentMonth {
                if dayDate < today {
                    content()
                        .foregroundColor(.gray)
                }else {
                    content()
                }
            }
        }
    }
    
    func modifySpecialDayView<Content: View>(
        model: CalendarModel.Day,
        @ViewBuilder content: () -> Content
    ) -> some View {
        contentBuilder {
            // some logic and view goes here
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfDay = calendar.startOfDay(for: model.date)
            let modifiedContent = content()
            
            if case .insideRange(.currentMonth) = model.rangeType {
                
                if (startOfDay < startOfToday) {
                    modifiedContent
                }else {
                    if specialDays.contains(date: model.date) , !specialDays.isEmpty {
                        modifiedContent
                            .overlay(
                                VStack(alignment: .trailing, content: {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 6, height: 6)
                                        .foregroundColor(OBBlue)
                                        .frame(maxWidth: .infinity,alignment: .trailing)
                                    Spacer()
                                })
                                .padding(8)
                                
                            )
                    }else {
                        modifiedContent
                    }
                }
            }else {
                Color.clear
            }
        }
    }
    
    func makeSpecialDaysView(year: Int, month: CalendarModel.Month) -> some View {
        contentBuilder {
            if specialDays.yearExist(year: year, calendar: calendar) {
                ForEach(month.days.indices, id: \.self) { index in
                    let day = month.days[index]
                    if case .insideRange(.currentMonth) = day.rangeType,
                       let specialDay = specialDays.get(year: year, month: month.month, day: day.day, calendar: calendar){
                        HStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 6, height: 6)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(OBBlue)
                            Text(specialDay.value)
                        }
                    }
                }
            }
        }
    }
}

private extension OBCalendarWithSpecialDay {
    static func makeColor(red: Int, green: Int, blue: Int) -> Color {
        Color(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255
        )
    }
    static func makeSpecialDays(calendar: Calendar) -> [Date?: String] {
        [
            calendar.date(from: DateComponents(year: 2024, month: 11, day: 25)): "Mock Event 1",
            calendar.date(from: DateComponents(year: 2025, month: 1, day: 1)): "New Year's Day",
            calendar.date(from: DateComponents(year: 2024, month: 12, day: 25)): "Christmas",
            calendar.date(from: DateComponents(year: 2024, month: 4, day: 23)): "National Sovereignty and Children's Day",
            calendar.date(from: DateComponents(year: 2024, month: 5, day: 1)): "Labor Day",
            calendar.date(from: DateComponents(year: 2024, month: 8, day: 30)): "Victory Day"
        ]

    }
    
}

extension Dictionary where Key == Date?, Value == String {
    func yearExist(year: Int, calendar: Calendar) -> Bool {
        self.contains { element in
            if let date = element.key {
                year == calendar.component(.year, from: date)
            }else {
                false
            }
        }
    }
    
    func get(year: Int, month: Int, day: Int, calendar: Calendar) -> Dictionary<Date?,String>.Element? {
        self.first { element in
            if let date = element.key {
                return year == calendar.component(.year, from: date)
                && month == calendar.component(.month, from: date)
                && day == calendar.component(.day, from: date)
            }else {
                return false
            }
        }
    }
    
    func contains(date: Date) -> Bool {
        self.contains { element in
            element.key ==  date
        }
    }
}

#Preview {
    let calendar = Calendar.current
    return OBCalendarWithSpecialDay(calendar)
}

