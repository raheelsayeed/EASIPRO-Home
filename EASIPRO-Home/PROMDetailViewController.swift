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
import AssessmentCenter

class PROMDetailViewController: UITableViewController {

	public var measure : PROMeasure2!
	
	var sessionController : SessionController2?
    
	@IBOutlet weak var graphView: LineGraphView!
	
    @IBOutlet weak var btnSession: RoundedButton!
    
    convenience init(measure: PROMeasure2) {
        self.init(style: .plain)
        self.measure = measure
    }
    
    @IBAction func sessionAction(_ sender: RoundedButton) {
        
        sessionController = SessionController2(patient: SMARTManager.shared.patient!, measures: [measure], practitioner: nil)
        
        sessionController?.prepareSessionContainer(callback: { [weak self] (viewController, error) in
            if let viewController = viewController {
                viewController.view.tintColor = .red
                self?.present(viewController, animated: true, completion: nil)
            }
        })
		
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = measure.identifier
		if let scores = measure.scores {
			graphView.graphPoints = scores
		}
		graphView.title = measure.title
		graphView.subtitle = measure.identifier
        btnSession.isHidden = (measure.sessionStatus != .due)
    }
	
	
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measure.results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SCORES"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OCell", for: indexPath)
		let o = measure.results![indexPath.row]
        cell.textLabel?.text = o.effectiveDateTime?.nsDate.shortDate
        cell.detailTextLabel?.text = o.valueString!.string
        return cell
    }


}
