//
//  EP+AssessmentCenter.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 03/05/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import Foundation
import AssessmentCenter
import EASIPRO
import ResearchKit


extension EASIPRO.SessionController2 {
	
	open func prepareSessionContainer(callback: @escaping ((UIViewController?, Error?) -> Void)) {
		guard let measures = measures else { return }
		
		
		let context = SMARTManager.shared.usageMode
		if context == .Patient {
			
			let acclient = ACClient.NewClient()
			let acForms = measures.map({ (prom) -> ACForm in
				return prom.measure as! ACForm
			})
			
			acclient.forms(acforms: acForms, completion: { [weak self] (completedForms) in
				if let completedForms = completedForms {
					let taskViewControllers = completedForms.map({ (form) -> ACTaskViewController in
						let acTVC = ACTaskViewController(acform: form, client: acclient, sessionIdentifier: (self?.patient.humanName!)!)
						acTVC.taskDelegate = self
						return acTVC
					})
					let navigationController = self?.sessionContainerController(for: taskViewControllers)
					callback(navigationController, nil)
				}
				else {
					callback(nil, nil)
				}
			})
		}
	}
}


extension EASIPRO.SessionController2 : ACTaskViewControllerDelegate {
	
	public func assessmentViewController(_ taskViewController: ACTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?, tscore: Double?, stderror: Double?, session: SessionItem) {
		
	}
	
	public func didDismissACTaskViewController() {
		
	}
}
