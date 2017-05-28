//
//  CWCalendarViewController.swift
//  Fiscal Year Calculator
//
//  Created by Stephen Ewell on 2/14/16.
//  Copyright © 2016 Stephen Ewell. All rights reserved.
//

import UIKit

class CWCalendarViewController: UICollectionViewController {
    
    private let reuseIdentifier = "DayCell"
    private let headerReuseIdentifier = "PeriodHeader"
    public let sectionInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
    private var year: CWFiscalYear!
    private var holidays: CWHolidays!
    private var todayNormalizedDate: Date!
    public var todayFiscalDate: CWFiscalDate!
    @IBOutlet weak var prevButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let util = CWFiscalDateUtilities()
        self.todayFiscalDate = CWFiscalDate()
        self.year = util.getFiscalYearForFiscalDate(self.todayFiscalDate)
        let today = Date()
        self.todayNormalizedDate = util.getNormalizedDate(today)
        self.holidays = CWHolidays(fiscalYear: todayFiscalDate.fiscalYear, country: .US)
        
        self.collectionView?.contentInset.top = 44
        let navBarFrame = self.navigationController!.navigationBar.frame
        let daysHeaderView = CWDaysHeaderView(frame: CGRect(x: 0, y: CGFloat(navBarFrame.maxY - 19.9), width: CGFloat(self.view.frame.size.width) , height: 44))
        daysHeaderView.blurTintColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(daysHeaderView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let year = self.todayFiscalDate.fiscalYear
        self.navigationItem.title = "FY \(year)"
        self.scrollTo(self.todayFiscalDate.day - 1, section: self.todayFiscalDate.period - 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dateForIndexPath(_ indexPath: IndexPath) -> CWFiscalDate {
        return self.year.periods[(indexPath as NSIndexPath).section].dates[(indexPath as NSIndexPath).row]
    }
    
    func periodForIndexPath(_ indexPath: IndexPath) -> CWFiscalPeriod {
        return self.year.periods[(indexPath as NSIndexPath).section]
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.year.periods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.year.periods[section].dates.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CWDayViewCell
        cell.topView.backgroundColor = UIColor.gray
        let dateFormatter = DateFormatter()
        let fiscalDate = self.dateForIndexPath(indexPath)
        let date = fiscalDate.storedDate
        
        if (date == self.todayNormalizedDate) {
            cell.dateLabel.textColor = UIColor.red
        } else {
            cell.dateLabel.textColor = UIColor.black
        }
        
        self.setUpTopLineView(cell:&cell, date: dateForIndexPath(indexPath))
        
        dateFormatter.setLocalizedDateFormatFromTemplate("d")
        cell.dateLabel.text = dateFormatter.string(from: dateForIndexPath(indexPath).storedDate as Date)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CWPeriodSectionHeader
        let periodAtIndex = self.periodForIndexPath(indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let lastDay = periodAtIndex.dates.count - 1
        let startMonth = formatter.string(from: periodAtIndex.dates[0].storedDate as Date)
        let endMonth = formatter.string(from: periodAtIndex.dates[lastDay].storedDate as Date)
        formatter.dateFormat = "yyyy"
        let startYear = formatter.string(from: periodAtIndex.dates[0].storedDate as Date)
        let endYear = formatter.string(from: periodAtIndex.dates[lastDay].storedDate as Date)
        
        
        header.sectionLabel.text = "Period \(periodAtIndex.period)"
        header.startLabel.text = startMonth + ", " + startYear
        header.endLabel.text = endMonth + ", " + endYear
        
        return header
    }
    
    func refreshCalander() {
        self.collectionView?.reloadData()
    }
    
    // MARK: DayViewCell layout
    func setUpTopLineView(cell: inout CWDayViewCell, date: CWFiscalDate) {
        // http://uicolor.xyz/#/hex-to-ui
        // Helpful site for float values from a hex value.
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date.storedDate)
        let month = components.month
        let monthColor: [UIColor] = [
                                        UIColor.gray,
                                        UIColor(red: 0, green: 0.263, blue: 0.345, alpha: 1),
                                        UIColor(red: 0.122, green: 0.541, blue: 0.439, alpha: 1),
                                        UIColor(red: 0.745, green: 0.859, blue: 0.224, alpha: 1),
                                        UIColor(red: 1, green: 0.882, blue: 0.102, alpha: 1),
                                        UIColor(red: 0.992, green: 0.455, blue: 0, alpha: 1),
                                        UIColor(red: 0.18, green: 0.035, blue: 0.153, alpha: 1),
                                        UIColor(red: 1, green: 0.549, blue: 0, alpha: 1),
                                        UIColor(red: 0.851, green: 0, blue: 0, alpha: 1),
                                        UIColor(red: 1, green: 0.176, blue: 0, alpha: 1),
                                        UIColor(red: 0.016, green: 0.459, blue: 0.435, alpha: 1),
                                        UIColor(red: 0.812, green: 0.29, blue: 0.188, alpha: 1),
                                        UIColor(red: 0.569, green: 0.067, blue: 0.275, alpha: 1),
                                    ]
        
        cell.topView.backgroundColor = monthColor[month!]
        cell.clearCircles()
        
        for d in self.holidays.holidays {
            if date.storedDate == d.date {
                cell.drawCircle()
                break
            }
        }
    }
    
    // MARK: @IBAction
    @IBAction func scrollToTodayButton() {
        let todaysDate = CWFiscalDate()
        if (self.year.fiscalYear != todaysDate.fiscalYear) {
            let util = CWFiscalDateUtilities()
            self.year = util.getFiscalYearForFiscalDate(todaysDate)
            let year = self.year.periods[0].dates[0].fiscalYear
            self.holidays = CWHolidays(fiscalYear: year, country: .US)
            self.collectionView!.reloadData()
            self.navigationItem.title = "FY \(year)"
        }
        
        self.scrollTo(todaysDate.day - 1, section: todaysDate.period - 1)
    }
    
    @IBAction func prevFiscalYear() {
        let util = CWFiscalDateUtilities()
        let prevFiscalYear = util.getPreviousYearForFiscalYear(self.year)
        self.year = prevFiscalYear
        let year = self.year.periods[0].dates[0].fiscalYear
        self.holidays = CWHolidays(fiscalYear: year, country: .US)
        self.collectionView!.reloadData()
        self.navigationItem.title = "FY \(year)"
        self.scrollTo(0, section: 0)
        
        if (self.year.fiscalYear <= 2001) {
            self.prevButton.isEnabled = false
        } else {
            self.prevButton.isEnabled = true
        }
    }
    
    @IBAction func nextFiscalYear() {
        let util = CWFiscalDateUtilities()
        let nextFiscalYear = util.getNextYearForFiscalYear(self.year)
        self.year = nextFiscalYear
        let year = self.year.periods[0].dates[0].fiscalYear
        self.holidays = CWHolidays(fiscalYear: year, country: .US)
        self.collectionView!.reloadData()
        self.navigationItem.title = "FY \(year)"
        self.scrollTo(0, section: 0)
        
        if (self.year.fiscalYear > 2001) {
            self.prevButton.isEnabled = true
        }
    }
    
    func scrollTo(_ item:Int, section:Int) {
        let indexPath = IndexPath(item: item, section: section)
        if (self.todayFiscalDate.week < 3) {
            collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: true)
        } else {
            collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
}


extension CWCalendarViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfColumns: CGFloat = 7
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 5)) / numberOfColumns
            return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}
