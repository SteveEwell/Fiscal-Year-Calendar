//
//  CWSettingsViewController.swift
//  Fiscal Year Calendar
//
//  Created by Stephen Ewell on 8/5/18.
//  Copyright © 2018 Stephen Ewell. All rights reserved.
//

import UIKit

class CWSettingsViewController: UITableViewController {
    @IBOutlet weak var selectedCountry: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setSelectedCountryLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setSelectedCountryLabel() {
        let defaults = UserDefaults.standard
        let country = defaults.object(forKey: "Country") as? String ?? "United States"

        self.selectedCountry.text = country
    }

    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {

    }
}
