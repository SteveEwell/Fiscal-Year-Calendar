//
//  CWHoliday.swift
//  Fiscal Year Calendar
//
//  Created by Stephen Ewell on 5/28/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import Foundation


enum DayOfMonth {
    case first
    case second
    case third
    case fourth
    case last
}

enum HolidayCountry {
    case US
    case CA
}

struct CWHoliday {
    let date: Date
    let country: String
    let name: String
    let open: Bool
}


class CWHolidays {
    var holidays: [CWHoliday]
    
    init(fiscalYear year: Int, country: HolidayCountry) {
        self.holidays = []
        switch country {
        case .US:
            let ct = "United States"
            self.laborDay(year: year - 1, country: ct)
            self.thanksgiving(year: year - 1, country: ct)
            self.christmas(year: year - 1, country: ct)
            self.newYearsDay(year: year, country: ct)
            self.martinLutherKingJr(year: year)
            self.goodFriday(year: year, country: ct)
            self.easter(year: year, country: ct)
            self.memorialDay(year: year, country: ct)
            self.independenceDay(year: year, country: ct)
        case .CA:
            let ct = "Canada"
            self.laborDay(year: year - 1, country: ct)
            self.thanksgiving(year: year - 1, country: ct)
        }
    }
    
    private func laborDay(year: Int, country: String) {
        let date = xDayOfMonthHoliday(year: year, month: 9, weekday: 2, dayOfMonth: .first)
        let holiday = CWHoliday(date: date, country: country, name: "Labor Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func thanksgiving(year: Int, country: String) {
        if country == "Canada" {
            let date = xDayOfMonthHoliday(year: year, month: 10, weekday: 2, dayOfMonth: .second)
            let holiday = CWHoliday(date: date, country: country, name: "Thanksgiving", open: false)
            self.holidays.append(holiday)
        } else {
            let date = xDayOfMonthHoliday(year: year, month: 11, weekday: 5, dayOfMonth: .fourth)
            let holiday = CWHoliday(date: date, country: country, name: "Thanksgiving (CA)", open: false)
            self.holidays.append(holiday)
        }
    }
    
    private func christmas(year: Int, country: String) {
        let date = dayOfMonthHoliday(year: year, month: 12, day: 25)
        let holiday = CWHoliday(date: date, country: country, name: "Christmas", open: false)
        self.holidays.append(holiday)
    }
    
    private func newYearsDay(year: Int, country: String) {
        let date = dayOfMonthHoliday(year: year, month: 1, day: 1)
        let holiday = CWHoliday(date: date, country: country, name: "New Years Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func  martinLutherKingJr(year: Int) {
        let date = xDayOfMonthHoliday(year: year, month: 1, weekday: 2, dayOfMonth: .third)
        let holiday = CWHoliday(date: date, country: "United States", name: "Martin Luther King Jr. Day", open: true)
        self.holidays.append(holiday)
    }
    
    private func goodFriday(year: Int, country: String) {
        let date = calcGoodFriday(year: year)
        let holiday = CWHoliday(date: date, country: country, name: "Good Friday", open: true)
        self.holidays.append(holiday)
    }
    
    private func easter(year: Int, country: String) {
        let date = calcEaster(year: year)
        let holiday = CWHoliday(date: date, country: country, name: "Easter", open: false)
        self.holidays.append(holiday)
    }
    
    private func memorialDay(year: Int, country: String) {
        let date = xDayOfMonthHoliday(year: year, month: 5, weekday: 2, dayOfMonth: .last)
        let holiday = CWHoliday(date: date, country: country, name: "Memorial Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func independenceDay(year: Int, country: String) {
        let date = dayOfMonthHoliday(year: year, month: 7, day: 4)
        let holiday = CWHoliday(date: date, country: country, name: "Independence Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func calcEaster(year: Int) -> Date {
        let a = year % 19
        let b = Int(floor(Double(year) / 100))
        let c = year % 100
        let d = Int(floor(Double(b) / 4))
        let e = b % 4
        let f = Int(floor(Double(b+8) / 25))
        let g = Int(floor(Double(b-f+1) / 3))
        let h = (19*a + b - d - g + 15) % 30
        let i = Int(floor(Double(c) / 4))
        let k = c % 4
        let L = (32 + 2*e + 2*i - h - k) % 7
        let m = Int(floor(Double(a + 11*h + 22*L) / 451))
        var components = DateComponents()
        components.year = year
        components.month = Int(floor(Double(h + L - 7*m + 114) / 31))
        components.day = ((h + L - 7*m + 114) % 31) + 1
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        return cal.date(from: components)!
    }
    
    private func calcGoodFriday(year: Int) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let easter = calcEaster(year: year)
        var offset = DateComponents()
        offset.day = 0 - 2
        return cal.date(byAdding: offset, to: easter)!
    }
    
    private func dayOfMonthHoliday(year: Int, month: Int, day: Int) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        let date = cal.date(from: components)
        return date!
    }
    
    
    private func xDayOfMonthHoliday(year: Int, month: Int, weekday: Int, dayOfMonth: DayOfMonth) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.weekday = weekday
        components.month = month
        components.year = year
        
        var days = [Date]()
        
        for i in 1...7 {
            components.weekdayOrdinal = i
            let dt = cal.date(from: components)
            let comp = cal.dateComponents([.month], from: dt!)
            if comp.month == month {
                days.append(dt!)
            }
        }
        
        switch dayOfMonth {
        case .first:
            return days.first!
        case .second:
            return days[1]
        case .third:
            return days[2]
        case .fourth:
            return days[3]
        case .last:
            return days.last!
        }
    }
}
