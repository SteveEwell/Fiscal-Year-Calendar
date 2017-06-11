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
    internal var hasDayHeader = false
    internal var firstView = true
    public var holidayCountry: HolidayCountry = .US
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
        self.year = util.fiscalYear(for: self.todayFiscalDate)
        let today = Date()
        self.todayNormalizedDate = util.getNormalizedDate(today)
        self.holidays = CWHolidays(fiscalYear: todayFiscalDate.year, country: self.holidayCountry)
        
        // Set up the days of the week header.
        if !self.hasDayHeader {
            self.collectionView?.contentInset.top = 44
            let navBarFrame = self.navigationController!.navigationBar.frame
            let daysHeaderView = CWDaysHeaderView(frame: CGRect(x: 0, y: CGFloat(navBarFrame.maxY - 19.9), width: CGFloat(self.view.frame.size.width) , height: 44))
            daysHeaderView.blurTintColor = UIColor.white
            self.navigationController?.navigationBar.addSubview(daysHeaderView)
            self.hasDayHeader = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.firstView {
            let year = self.todayFiscalDate.year
            self.navigationItem.title = "FY \(year)"
            self.scrollTo(self.todayFiscalDate.day - 1, section: self.todayFiscalDate.period - 1)
            self.firstView = false
        }
        
        if !self.hasDayHeader {
            self.collectionView?.contentInset.top = 44
            let navBarFrame = self.navigationController!.navigationBar.frame
            let daysHeaderView = CWDaysHeaderView(frame: CGRect(x: 0, y: CGFloat(navBarFrame.maxY - 19.9), width: CGFloat(self.view.frame.size.width) , height: 44))
            daysHeaderView.blurTintColor = UIColor.white
            self.navigationController?.navigationBar.addSubview(daysHeaderView)
            self.hasDayHeader = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dateForIndexPath(_ indexPath: IndexPath) -> CWFiscalDate {
        return self.year.periods[(indexPath).section].dates[(indexPath).row]
    }
    
    func periodForIndexPath(_ indexPath: IndexPath) -> CWFiscalPeriod {
        return self.year.periods[(indexPath).section]
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.year.periods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.year.periods[section].dates.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CWDayViewCell
        cell.topView.backgroundColor = UIColor.gray
        let dateFormatter = DateFormatter()
        let fiscalDate = self.dateForIndexPath(indexPath)
        let date = fiscalDate.date
        
        if (date == self.todayNormalizedDate) {
            cell.dateLabel.textColor = UIColor.red
        } else {
            cell.dateLabel.textColor = UIColor.black
        }
        
        cell.clearCircles()
        cell.isUserInteractionEnabled = false
        cell.holiday = nil
        cell.setUpTopLineView(date: fiscalDate)
        
        for d in self.holidays.holidays {
            if date == d.date {
                cell.holiday = d
                cell.drawCircleHoliday()
                cell.isUserInteractionEnabled = true
                break
            }
        }
        
        dateFormatter.setLocalizedDateFormatFromTemplate("d")
        cell.dateLabel.text = dateFormatter.string(from: dateForIndexPath(indexPath).date)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CWPeriodSectionHeader
        let periodAtIndex = self.periodForIndexPath(indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let lastDay = periodAtIndex.dates.count - 1
        let startMonth = formatter.string(from: periodAtIndex.dates[0].date)
        let endMonth = formatter.string(from: periodAtIndex.dates[lastDay].date)
        formatter.dateFormat = "yyyy"
        let startYear = formatter.string(from: periodAtIndex.dates[0].date)
        let endYear = formatter.string(from: periodAtIndex.dates[lastDay].date)
        
        
        header.sectionLabel.text = "Period \(periodAtIndex.period)"
        header.startLabel.text = startMonth + ", " + startYear
        header.endLabel.text = endMonth + ", " + endYear
        
        return header
    }
    
    func refreshCalender() {
        let util = CWFiscalDateUtilities()
        self.todayFiscalDate = CWFiscalDate()
        let today = self.todayFiscalDate.date
        self.todayNormalizedDate = util.getNormalizedDate(today)
        self.collectionView!.reloadData()
    }
    
    // MARK: @IBAction
    @IBAction func scrollToTodayButton() {
        let todaysDate = CWFiscalDate()
        if (self.year.fiscalYear != todaysDate.year) {
            let util = CWFiscalDateUtilities()
            self.year = util.fiscalYear(for: todaysDate)
            let year = self.year.periods[0].dates[0].year
            self.holidays = CWHolidays(fiscalYear: year, country: self.holidayCountry)
            self.collectionView!.reloadData()
            self.navigationItem.title = "FY \(year)"
        }
        
        self.scrollTo(todaysDate.day - 1, section: todaysDate.period - 1)
    }
    
    @IBAction func prevFiscalYear() {
        let util = CWFiscalDateUtilities()
        let prevFiscalYear = util.previousYear(for: self.year)
        self.year = prevFiscalYear
        let year = self.year.periods[0].dates[0].year
        self.holidays = CWHolidays(fiscalYear: year, country: self.holidayCountry)
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
        let nextFiscalYear = util.nextYear(for: self.year)
        self.year = nextFiscalYear
        let year = self.year.periods[0].dates[0].year
        self.holidays = CWHolidays(fiscalYear: year, country: self.holidayCountry)
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

// MARK: Extensions
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

extension CWCalendarViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDayDetail" {
            for v in (self.navigationController?.navigationBar.subviews)! {
                if v is CWDaysHeaderView {
                    v.removeFromSuperview()
                    self.hasDayHeader = false
                    break
                }
            }
            if let controller = segue.destination as? CWDayDetailViewController {
                if let cell = sender as? CWDayViewCell {
                    if let holiday = cell.holiday {
                        controller.holiday = holiday
                    }
                }
            }
        }
    }
}
