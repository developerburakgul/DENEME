//
//  OBCalendarDemoDoubleSelection.swift
//  OBCalendarDemoDoubleSelection
//
//  Created by Burak Gül on 19.11.2024.
//

import SwiftUI
import ObiletCalendar

struct  OBCalendarDemoDoubleSelection: View {
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
    let selectedBetweenOBBackgroundColor = Self.makeColor(red: 185, green: 202, blue: 219)
    let secondSelectedOBBackgroundColor: some View = Circle()
        .foregroundColor(Self.makeColor(red: 47, green: 91, blue: 141))
        .overlay(
            Circle()
                .foregroundColor(.white)
                .padding(2)
        )
    
    @State var firstSelectedDate: Date?
    @State var secondSelectedDate: Date?
    
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
                .padding(.vertical,4)
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
            
            
            if model.isInRangeCurrentMonth {
                if (dayDate < today) {
                    content()
                        .foregroundColor(.gray)
                }else {
                    if model.date == firstSelectedDate || model.date == secondSelectedDate{
                        modifySelectedDayView(date: model.date, content: content)
                    }else {
                        modifyBetweenSelectedDateView(date: model.date, content: content)
                    }
                }
            }else {
                Color.clear
            }
        }
    }
    
    func modifySelectedDayView<Content: View>(date: Date, @ViewBuilder content: () -> Content) -> some View {
        
        contentBuilder {
            
            
            
            let isFirstSelected = date == firstSelectedDate && secondSelectedDate != nil
            let isSecondSelected = date == secondSelectedDate && firstSelectedDate != nil
            let isSingleSelectedDate = firstSelectedDate == nil || secondSelectedDate == nil
            
            let config: (corners: UIRectCorner, edges: Edge.Set) = isFirstSelected
            ? ([.topLeft, .bottomLeft], .leading)
            : isSecondSelected
            ? ([.topRight, .bottomRight], .trailing)
            : ([], .all)
            
            let modifiedContent = content()
                .background(
                    contentBuilder{
                        if (isFirstSelected || isSingleSelectedDate) {
                            selectedOBBackgroundColor
                        }else {
                            secondSelectedOBBackgroundColor
                        }
                    }
                )
                .foregroundColor( isFirstSelected || isSingleSelectedDate ? .white : .black)
            
            if isSingleSelectedDate {
                modifiedContent
                    .background(
                        selectedOBBackgroundColor
                    )
            }else {
                modifiedContent
                    .background(
                        selectedBetweenOBBackgroundColor
                            .clipShape(RoundedCornersShape(corners: config.corners, radius: 17.5))
                            .padding(config.edges)
                        
                    )
            }
            
        }
    }
    
    func modifyBetweenSelectedDateView<Content: View>(date: Date, @ViewBuilder content: () -> Content) -> some View {
        contentBuilder {
            
            if let firstSelectedDate, let secondSelectedDate, date > firstSelectedDate && date < secondSelectedDate {
                content()
                    .background(selectedBetweenOBBackgroundColor)
            }else {
                content()
            }
        }
    }
    
    func selectDate(of day: CalendarModel.Day) {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfDay = calendar.startOfDay(for: day.date)
        let date = day.date
        
        
        if day.isInRangeCurrentMonth {
            if startOfDay >= startOfToday {
                if firstSelectedDate == nil  {
                    firstSelectedDate = date
                }else if secondSelectedDate == nil {
                    if let firstSelectedDate , date < firstSelectedDate {
                        secondSelectedDate = firstSelectedDate
                        self.firstSelectedDate = date
                    }else {
                        secondSelectedDate = date
                    }
                }else {
                    firstSelectedDate = date
                    secondSelectedDate = nil
                }
            }
        }
    }
}

private struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

private extension OBCalendarDemoDoubleSelection {
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
    return  OBCalendarDemoDoubleSelection(calendar)
}

