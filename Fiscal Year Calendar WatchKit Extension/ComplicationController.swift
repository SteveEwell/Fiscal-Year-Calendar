//
//  ComplicationController.swift
//  Fiscal Year Calendar WatchKit Extension
//
//  Created by Stephen Ewell on 5/7/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let dataProvider = DataProvider()
    
    // MARK: - Setup Template
    
    func templateCircularSmallRingForData(_ data: CWFiscalDate) -> CLKComplicationTemplate {
        let template = CLKComplicationTemplateCircularSmallRingText()
        template.textProvider = CLKSimpleTextProvider(text: data.periodAsString)
        template.fillFraction = data.fraction
        template.ringStyle = .closed
        return template
    }
    
    func placeholderTemplateCircularSmallRing() -> CLKComplicationTemplate {
        let template = CLKComplicationTemplateCircularSmallRingText()
        template.textProvider = CLKSimpleTextProvider(text: "--")
        template.fillFraction = 1.0
        template.ringStyle = .closed
        return template
    }
    
    func templateModularSmallForData(_ data: CWFiscalDate) -> CLKComplicationTemplate {
        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = CLKSimpleTextProvider.init(text: "PR")
        template.row2Column1TextProvider = CLKSimpleTextProvider.init(text: "WK")
        template.row1Column2TextProvider = CLKSimpleTextProvider.init(text: data.periodAsString)
        template.row2Column2TextProvider = CLKSimpleTextProvider.init(text: data.weekAsString)
        return template
    }
    
    func placeholderTemplateModularSmall() -> CLKComplicationTemplate {
        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = CLKSimpleTextProvider.init(text: "PR")
        template.row2Column1TextProvider = CLKSimpleTextProvider.init(text: "WK")
        template.row1Column2TextProvider = CLKSimpleTextProvider.init(text: "--")
        template.row2Column2TextProvider = CLKSimpleTextProvider.init(text: "--")
        return template
    }
    
    func templateModularLargeForData(_ data: CWFiscalDate) -> CLKComplicationTemplate {
        let template = CLKComplicationTemplateModularLargeColumns()
        template.row1Column1TextProvider = CLKSimpleTextProvider.init(text: "YEAR")
        template.row2Column1TextProvider = CLKSimpleTextProvider.init(text: "PERIOD")
        template.row3Column1TextProvider = CLKSimpleTextProvider.init(text: "WEEK")
        template.row1Column2TextProvider = CLKSimpleTextProvider.init(text: data.yearAsString)
        template.row2Column2TextProvider = CLKSimpleTextProvider.init(text: data.periodAsString)
        template.row3Column2TextProvider = CLKSimpleTextProvider.init(text: data.weekAsString)
        return template
    }
    
    func placeholderTemplateModularLarge() -> CLKComplicationTemplate {
        let template = CLKComplicationTemplateModularLargeColumns()
        template.row1Column1TextProvider = CLKSimpleTextProvider.init(text: "YEAR")
        template.row2Column1TextProvider = CLKSimpleTextProvider.init(text: "PERIOD")
        template.row3Column1TextProvider = CLKSimpleTextProvider.init(text: "WEEK")
        template.row1Column2TextProvider = CLKSimpleTextProvider.init(text: "--")
        template.row2Column2TextProvider = CLKSimpleTextProvider.init(text: "--")
        template.row3Column2TextProvider = CLKSimpleTextProvider.init(text: "--")
        return template
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(dataProvider.thirtyDaysData().first!.date)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(dataProvider.thirtyDaysData().last!.date)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func timelineEntryForData(_ data: CWFiscalDate, complication: CLKComplication) -> CLKComplicationTimelineEntry {
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = templateModularSmallForData(data)
        case .modularLarge:
            template = templateModularLargeForData(data)
        case .circularSmall:
            template = templateCircularSmallRingForData(data)
        default:
            template = nil
        }
        return CLKComplicationTimelineEntry(date: data.date, complicationTemplate: template!)
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let data = dataProvider.thirtyDaysData().dataForNow() {
            handler(timelineEntryForData(data, complication: complication))
        } else {
            let dt = Date()
            handler(CLKComplicationTimelineEntry(date: dt, complicationTemplate: getPlaceholder(for: complication)))
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let entries = dataProvider.thirtyDaysData().filter{
            date.compare($0.date as Date) == .orderedDescending
            }.map{
                self.timelineEntryForData($0, complication: complication)
        }
        handler(entries)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let entries = dataProvider.thirtyDaysData().filter{
            date.compare($0.date as Date) == .orderedAscending
            }.map{
                self.timelineEntryForData($0, complication: complication)
        }
        handler(entries)
    }
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        handler(Date.endOfToday());
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholder(for complication: CLKComplication) -> CLKComplicationTemplate {
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = placeholderTemplateModularSmall()
        case .modularLarge:
            template = placeholderTemplateModularLarge()
        case .circularSmall:
            template = placeholderTemplateCircularSmallRing()
        default:
            template = nil
        }
        return template!
    }
    
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = placeholderTemplateModularSmall()
        case .modularLarge:
            template = placeholderTemplateModularLarge()
        case .circularSmall:
            template = placeholderTemplateCircularSmallRing()
        default:
            template = nil
        }
        handler(template)
    }
}
