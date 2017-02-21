//
//  SelectCardViewController.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 2/19/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit

class SelectCardVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var allCardsView: UITableView!
    
    var cellReuseIdentifier = "cell"
    var selectedRow: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //TableView Configuration
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProviderList().allProvidersArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
        cell.imageView?.image = UIImage(named: ProviderList().allProvidersArray[indexPath.item])
        cell.textLabel?.text = ProviderList().allProvidersArray[indexPath.item]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "backWithSelectedCard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if(segue.identifier == "backWithSelectedCard") {
            let vc = segue.destination as! AddCardVC
            vc.selectedCardType = selectedRow
        }
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
