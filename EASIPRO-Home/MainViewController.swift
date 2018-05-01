//
//  MainViewController.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/1/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import EASIPRO

class MainViewController: UITableViewController {
    
    
    let smartClient = SMARTManager.shared.client
    
    var measures : [PROMeasure2]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .automatic
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @IBAction func refreshPage(_ sender: Any) {
        SMARTManager.shared.client.ready { [unowned self] (error) in
            DispatchQueue.main.async {
                SMARTManager.shared.showLoginController(over: self)
            }
        }
    }
}
