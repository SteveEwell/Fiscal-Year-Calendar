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
    case US // United States
    case CA // Canada
    case PR // Puerto Rico
    case IS // Iceland
    case GB // United Kingdom
    case MX // Mexico
    case FR // France
    case TW // Taiwan
    case JP // Japan
    case KR // Korea
    case AU // Australia
    case ES // Spain
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
            self.halloween(year: year - 1, country: ct)
            self.thanksgiving(year: year - 1, country: ct)
            self.christmas(year: year - 1, country: ct)
            self.newYearsDay(year: year, country: ct)
            self.martinLutherKingJr(year: year)
            self.valentinesDay(year: year, country: ct)
            self.goodFriday(year: year, country: ct)
            self.easter(year: year, country: ct)
            self.mothersDay(year: year, country: ct)
            self.memorialDay(year: year, country: ct)
            self.fathersDay(year: year, country: ct)
            self.independenceDay(year: year, country: ct)
        case .CA:
            let ct = "Canada"
            self.laborDay(year: year - 1, country: ct)
            self.thanksgiving(year: year - 1, country: ct)
            self.halloween(year: year - 1, country: ct)
            self.remembranceDay(year: year - 1, country: ct)
            self.christmas(year: year - 1, country: ct)
            self.boxingDay(year: year - 1, country: ct)
            self.newYearsDay(year: year, country: ct)
            self.familyDay(year: year, country: ct)
            self.valentinesDay(year: year, country: ct)
            self.goodFriday(year: year, country: ct)
            self.easter(year: year, country: ct)
            self.victoriaDay(year: year, country: ct)
            self.stJeanBaptisteDay(year: year, country: ct)
            self.canadaDay(year: year, country: ct)
            self.civicDay(year: year, country: ct)
        default:
            self.holidays = []
        }
    }
    
    private func laborDay(year: Int, country: String) {
        let date = self.xDayOfMonthHoliday(year: year, month: 9, weekday: 2, dayOfMonth: .first)
        let holiday = CWHoliday(date: date, country: country, name: "Labor Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func halloween(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 10, day: 31)
        let holiday = CWHoliday(date: date, country: country, name: "Halloween", open: true)
        self.holidays.append(holiday)
    }
    
    private func thanksgiving(year: Int, country: String) {
        if country == "Canada" {
            let date = self.xDayOfMonthHoliday(year: year, month: 10, weekday: 2, dayOfMonth: .second)
            let holiday = CWHoliday(date: date, country: country, name: "Thanksgiving", open: false)
            self.holidays.append(holiday)
        } else {
            let date = self.xDayOfMonthHoliday(year: year, month: 11, weekday: 5, dayOfMonth: .fourth)
            let holiday = CWHoliday(date: date, country: country, name: "Thanksgiving", open: false)
            self.holidays.append(holiday)
        }
    }
    
    private func christmas(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 12, day: 25)
        let holiday = CWHoliday(date: date, country: country, name: "Christmas", open: false)
        self.holidays.append(holiday)
    }
    
    private func newYearsDay(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 1, day: 1)
        let holiday = CWHoliday(date: date, country: country, name: "New Years Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func  martinLutherKingJr(year: Int) {
        let date = self.xDayOfMonthHoliday(year: year, month: 1, weekday: 2, dayOfMonth: .third)
        let holiday = CWHoliday(date: date, country: "United States", name: "Martin Luther King Jr. Day", open: true)
        self.holidays.append(holiday)
    }
    
    private func valentinesDay(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 2, day: 14)
        let holiday = CWHoliday(date: date, country: country, name: "Valentine's Day", open: true)
        self.holidays.append(holiday)
    }
    
    private func goodFriday(year: Int, country: String) {
        let date = self.calcGoodFriday(year: year)
        let holiday = CWHoliday(date: date, country: country, name: "Good Friday", open: true)
        self.holidays.append(holiday)
    }
    
    private func easter(year: Int, country: String) {
        let date = self.calcEaster(year: year)
        let holiday = CWHoliday(date: date, country: country, name: "Easter", open: false)
        self.holidays.append(holiday)
    }
    
    private func mothersDay(year: Int, country: String) {
        let date = self.xDayOfMonthHoliday(year: year, month: 5, weekday: 1, dayOfMonth: .second)
        let holiday = CWHoliday(date: date, country: country, name: "Mother's Day", open: true)
        self.holidays.append(holiday)
    }
    
    private func memorialDay(year: Int, country: String) {
        let date = self.xDayOfMonthHoliday(year: year, month: 5, weekday: 2, dayOfMonth: .last)
        let holiday = CWHoliday(date: date, country: country, name: "Memorial Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func fathersDay(year: Int, country: String) {
        let date = self.xDayOfMonthHoliday(year: year, month: 6, weekday: 1, dayOfMonth: .third)
        let holiday = CWHoliday(date: date, country: country, name: "Father's Day", open: true)
        self.holidays.append(holiday)
    }
    
    private func independenceDay(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 7, day: 4)
        let holiday = CWHoliday(date: date, country: country, name: "Independence Day", open: false)
        self.holidays.append(holiday)
    }

    private func remembranceDay(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 11, day: 11)
        let holiday = CWHoliday(date: date, country: country, name: "Remembrance Day", open: true)
        self.holidays.append(holiday)
    }

    private func boxingDay(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 12, day: 26)
        let holiday = CWHoliday(date: date, country: country, name: "Boxing Day", open: true)
        self.holidays.append(holiday)
    }

    private func familyDay(year: Int, country: String) {
        let date1 = self.xDayOfMonthHoliday(year: year, month: 2, weekday: 2, dayOfMonth: .second)
        let holiday1 = CWHoliday(date: date1, country: country, name: "Family Day (BC)", open: false)
        self.holidays.append(holiday1)

        let date2 = self.xDayOfMonthHoliday(year: year, month: 2, weekday: 2, dayOfMonth: .third)
        let holiday2 = CWHoliday(date: date2, country: country, name: "Family Day", open: false)
        self.holidays.append(holiday2)
    }

    private func victoriaDay(year: Int, country: String) {
        let date = self.calcVictoriaDay(year: year)
        let holiday = CWHoliday(date: date, country: country, name: "Victoria Day", open: false)
        self.holidays.append(holiday)
    }

    private func stJeanBaptisteDay(year: Int, country: String) {
        let date = self.dayOfMonthHoliday(year: year, month: 12, day: 26)
        let holiday = CWHoliday(date: date, country: country, name: "St. Jean Baptiste", open: true)
        self.holidays.append(holiday)
    }

    private func canadaDay(year: Int, country: String) {
        let date = self.calcCanadaDay(year: year)
        let holiday = CWHoliday(date: date, country: country, name: "Canada Day", open: false)
        self.holidays.append(holiday)
    }
    
    private func civicDay(year: Int, country: String) {
        let date = self.xDayOfMonthHoliday(year: year, month: 8, weekday: 2, dayOfMonth: .first)
        let holiday = CWHoliday(date: date, country: country, name: "Civic Day", open: true)
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
        let easter = self.calcEaster(year: year)
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

    private func calcVictoriaDay(year: Int) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.weekday = 2
        components.month = 5
        components.year = year

        var days = [Date]()

        for i in 1...7 {
            components.weekdayOrdinal = i
            let dt = cal.date(from: components)
            let comp = cal.dateComponents([.month, .day], from: dt!)
            if comp.month! == 5 && comp.day! < 25 {
                days.append(dt!)
            }
        }
        return days.last!
    }

    private func calcCanadaDay(year: Int) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        var date = self.dayOfMonthHoliday(year: year, month: 7, day: 1)
        let comp = cal.dateComponents([.weekday], from: date)

        if comp.weekday == 1 {
            date = self.dayOfMonthHoliday(year: year, month: 7, day: 2)
        }

        return date
    }

}
