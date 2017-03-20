//
//  SettingsView.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 2/12/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit

class Settings : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //TableView Configuration
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingItemsList().settingsItems.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
        cell.textLabel?.text = SettingItemsList().settingsItems[indexPath.item]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
