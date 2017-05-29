//
//  CWDayDetailViewController.swift
//  Fiscal Year Calendar
//
//  Created by Stephen Ewell on 5/29/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import UIKit

class CWDayDetailViewController: UIViewController {
    var holiday: CWHoliday?
    @IBOutlet weak var holidayName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let h = self.holiday {
            self.holidayName.text = h.name
        } else {
            self.holidayName.text = "Not Avalible"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
