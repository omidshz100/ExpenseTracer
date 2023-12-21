//
//  Date+Extension.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 21/12/23.
//

import Foundation


extension Date{
    
    var startOfMonth:Date {
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.year, .month], from: self)
        // بصورت تجربی تاریخ اولین روز ماه رو محاسبه میکنه
        // یعنی همین کد
        return calender.date(from: dateComponent) ?? self
    }
    
    
    var endOfMonth:Date{
        let calender = Calendar.current
        
        return calender.date(byAdding: .init(month: 1, minute: -1), to: self.startOfMonth) ?? self
    }
}
