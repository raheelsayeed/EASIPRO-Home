//
//  PROMDetailViewController.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/2/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import EASIPRO

class PROMDetailViewController: UITableViewController {

    public var measure : PROMeasure2!
    
    
    
    convenience init(measure: PROMeasure2) {
        self.init(style: .plain)
        self.measure = measure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PROMIS"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Slots"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OCell", for: indexPath)
        cell.textLabel?.text = "Date"
        cell.detailTextLabel?.text = "56.0"
        return cell
    }


}
