//
//  PROMDetailViewController.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/2/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import EASIPRO
import SMART

class PROMDetailViewController: UITableViewController {

	public var measure : PROMeasure2! {
		didSet {
			observations = measure.results

		}
	}
	
	var observations : [Observation]?
    
	@IBOutlet weak var graphView: LineGraphView!
	
    
    convenience init(measure: PROMeasure2) {
        self.init(style: .plain)
        self.measure = measure
		
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = measure.title
		if let scores = measure.scores {
			graphView.graphPoints = scores
		}
		graphView.title = measure.title
		graphView.subtitle = measure.identifier
    }
	
	
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Slots"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OCell", for: indexPath)
		let o = observations![indexPath.row]
        cell.textLabel?.text = o.effectiveDateTime?.date.description
        cell.detailTextLabel?.text = o.valueString!.string
        return cell
    }


}
