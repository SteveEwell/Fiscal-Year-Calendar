//
//  DataProvider.swift
//  Fiscal Year Calendar
//
//  Created by Stephen Ewell on 5/20/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import Foundation


extension Collection where Iterator.Element: FiscalDate {
    func dataForNow() -> Iterator.Element? {
        let thisDay = CWFiscalDate()
        for d in self {
            if d.period == thisDay.period && d.week == thisDay.week && d.day == thisDay.day {
                return d
            }
        }
        return nil
    }
}

struct DataProvider {
    func threeDaysData() -> [CWFiscalDate] {
        let now = CWFiscalDate()
        let calendar: Calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 0 - 1
        let startDate = calendar.date(byAdding: offset, to: now.date)
        let startFiscalDate = CWFiscalDate(from: startDate!)
        var datesArray = [CWFiscalDate]()
        datesArray.append(startFiscalDate)
        for i in 1..<3 {
            offset.day = i
            let nextDay = calendar.date(byAdding: offset, to: startDate!)
            let nextFiscalDay = CWFiscalDate(from: nextDay!)
            datesArray.append(nextFiscalDay)
        }
        return datesArray
    }
}

extension Date {
    static func endOfToday() -> Date{
        let cal = Calendar.current
        
        let unitsArray: [Calendar.Component] = [.year, .month, .day]
        let units = Set(unitsArray)
        
        var comps = cal.dateComponents(units, from: Date())
        comps.hour = 23
        comps.minute = 59
        comps.second = 59
        return cal.date(from: comps)!
    }
}

extension CWFiscalDate {
    var fraction: Float {
        if (self.year > 2000 && Int(self.year % 6) == 1) && self.period == 13 {
            return Float(self.week) / 5.0
        } else {
            return Float(self.week) / 4.0
        }
    }
}
