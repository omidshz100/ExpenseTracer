# ExpenseTracer

ExpenseTracer is an iPhone app for recording income and expenses. It is built with SwiftUI and SwiftData, and includes a home-screen widget for the current month.

## What it does

- Add, edit, and delete income and expense transactions.
- Filter by date and search by title or notes.
- See monthly totals and a bar chart.
- Lock the app with Face ID.
- Show this month's income, expense, and balance in a widget.

The app and the widget share one SwiftData store through the App Group `group.com.app.ExpenseTracer`. Enable that group for both targets in the Apple Developer portal before running on a device.

## Requirements

- Xcode 15 or newer
- iOS 17 or newer (the widget target uses iOS 17.2)

Open `ExpenseTracer.xcodeproj` and run the ExpenseTracer scheme.
