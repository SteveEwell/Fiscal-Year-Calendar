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
    func thirtyDaysData() -> [CWFiscalDate] {
        let now = CWFiscalDate()
        let calendar: Calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 0 - 15
        let startDate = calendar.date(byAdding: offset, to: now.storedDate)
        let startFiscalDate = CWFiscalDate(fromDate: startDate!)
        var datesArray = [CWFiscalDate]()
        datesArray.append(startFiscalDate)
        for i in 1..<30 {
            offset.day = i
            let nextDay = calendar.date(byAdding: offset, to: startDate!)
            let nextFiscalDay = CWFiscalDate(fromDate: nextDay!)
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
