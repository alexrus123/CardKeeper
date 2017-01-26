//
//  ViewController.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 1/16/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//
// Starting1
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    var returnedCards = CDhelper().fetchCoreData()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any 1additional setup after loading the view, typically from a nib.
        
        // Register the table view cell class and its reuse id
        self.tableView.rowHeight = 80.0
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnedCards.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        //var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
        
        if(returnedCards.count==0){
            cell.textLabel!.text="No cards"}
        else{
        
            //if (cell == nil){
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
            //}
            
            cell.imageView?.image = UIImage(named: self.returnedCards[indexPath.row].cardProvider!)
            cell.textLabel!.text = self.returnedCards[indexPath.row].cardName!
            cell.textLabel!.textAlignment = .right
            cell.detailTextLabel?.text = String(describing: self.returnedCards[indexPath.row].cardNumber)
            cell.detailTextLabel?.textAlignment = .right
            /*
            let cellImg : UIImageView = UIImageView(frame: CGRect(x: 5, y: 5,width: 100, height: 80))
            cellImg.image = UIImage(named: self.returnedCards[indexPath.row].cardProvider!)
            cell.addSubview(cellImg)
            */
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

