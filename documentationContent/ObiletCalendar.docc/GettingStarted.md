#  Getting Started

## Requirements
- iOS 14+
- Swift 5.10+

## Installation
To integrate OBCalendar into your project using Swift Package Manager, follow these steps:

- Open your Xcode project.
- Go to File > Add Packages.
- In the search bar, enter the following URL :
```
https://github.com/oBilet/OBCalendar.git
```
- Choose the package version 0.2.1 and click Add Package.


## Usage
> [!Note]
> For better performance, use `lazyDays: true` and `lazyMonths: true`.
> If you are using programmatic scroll, set `lazyYears: false` because subviews need to be loaded into memory once for ScrollViewProxy to recognize their id values.

- You can create ``OBCalendar`` specifying `startDate` (default is now) and DrawingRange (day, month or year from startDate) (default `drawingRange` is `.year(1)`).
- [dayModifier](<doc:OBCalendar/dayModifier(_:)>), [monthModifier](<doc:OBCalendar/monthModifier(_:)>) and [yearModifier](<doc:OBCalendar/yearModifier(_:)>) are optional and you can choose to use `baseView` or use the packed views (daysView, monthsView) inside the modifiers or you can return your custom view.
- The first model consists of ``CalendarModel/Year``, ``CalendarModel/Month`` and ``CalendarModel/Day`` and a view is created for each day using this model in the first block.
- Modifiers should be written in this order: [dayModifier](<doc:OBCalendar/dayModifier(_:)>) -> [monthModifier](<doc:OBCalendar/monthModifier(_:)>) -> [yearModifier](<doc:OBCalendar/yearModifier(_:)>)
- `baseView` in the modifier closures is the default view that has its own custom modification over the previous modifier method's return type, like having a header in months for example.
- `daysView` in the [monthModifier](<doc:OBCalendar/monthModifier(_:)>) and `monthsView` in the [yearModifier](<doc:OBCalendar/yearModifier(_:)>) are the untouched pack of views that will have the modifications from previous modifiers.
- Every modifier has its own related data type packed as a tuple in the closure parameter list. Default name is "model" and it has ``CalendarModel/Year``, ``CalendarModel/Month`` and ``CalendarModel/Day``.
- The models provided to the closures are: `Day` + `Month` + `Year` for [dayModifier](<doc:OBCalendar/dayModifier(_:)>), `Month` +`Year` for [monthModifier](<doc:OBCalendar/monthModifier(_:)>) and only `Year` for [yearModifier](<doc:OBCalendar/yearModifier(_:)>).

- You can fully customize the view for each day, month, and year using [dayModifier](<doc:OBCalendar/dayModifier(_:)>), [monthModifier](<doc:OBCalendar/monthModifier(_:)>) and [yearModifier](<doc:OBCalendar/yearModifier(_:)>) which do take `ViewBuilder` blocks.
- This structure provides a seamless and dynamic user experience.

- If you'd like to create the calendar from scratch, you can use the base version of it as well. You can customize it even further by setting sart and end dates to generating and providing your own date array for custom layouts.

Default:
```swift
// 1 year of drawing range
OBCalendar(drawingRange: .year(1))

// 3 months of drawing range
OBCalendar(drawingRange: .month(3))

// 60 days of drawing range
OBCalendar(drawingRange: .day(60))
```
Horizontal Scroll:
```swift
GeometryReader { geometry in
      OBCalendar(
          monthScrollAxis: .horizontal,
          yearScrollAxis: .horizontal
      )
      .monthModifier { baseView, daysView, model in
          baseView
              .padding()
              .frame(width: geometry.size.width)
      }
}
```

DayModifier:
```swift
 OBCalendar()
      .dayModifier { baseView, model in
          baseView
              .background(Color.blue)
              .padding(2)
              .foregroundColor(.white)
      }
```

MonthModifier:
```swift
OBCalendar()
      .monthModifier{ baseView, daysView, model in
          VStack {
              Text("Modified Months")
                 daysView
          }
          .padding()
      }
```

Modified Day + Modified Month:
```swift
OBCalendar()
      .dayModifier { baseView, model in
          baseView
              .foregroundColor(Color(.red))
      }
      .monthModifier { baseView, daysView, model in
          VStack {
              Text("Modified Months")
              daysView
          }
          .padding()
      }
```

BaseCalendar
```swift
let today = Date()
let twoYearsLater = calendar.date(byAdding: .year, value: 2, to: today)!

OBBaseCalendar(startDate: today, endDate: twoYearsLater) { model, scrollProxy in
    // day view goes here
    let day = model.day
    Text("\(day.day)")
} monthContent: { model, scrollProxy, daysView in
    // month view goes here
    daysView
} yearContent: { model, scrollProxy, monthsView in
    // year view goes here
    monthsView
}
```

BaseCalendar + Custom layouts
```swift
//Implement your own layout
let years = [CalendarModel.Year]() 

// Or use default layout
let defaultLayout = CalendarModelBuilder.defaultLayout(
      calendar: .current,
      startDate: Date(),
      endDate: Date().addingTimeInterval(3600 * 24 * 365)
)

OBBaseCalendar(years: years) { model, scrollProxy in
    // day view goes here
    let day = model.day
    Text("\(day.day)")
} monthContent: { model, scrollProxy, daysView in
    // month view goes here
    daysView
} yearContent: { model, scrollProxy, monthsView in
    // year view goes here
    monthsView
}
```

****

Feel free to explore the SwiftUI-powered flexibility of `OBCalendar` to meet your custom calendar needs!













