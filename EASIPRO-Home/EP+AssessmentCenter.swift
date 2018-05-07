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
import SMART


extension AssessmentCenter.ACForm {
	
	func proMeasure() -> PROMeasure2 {
		let identifier = measureIdentifier()
		let title = self.title ?? identifier
		let prom = PROMeasure2(title: title, identifier: identifier)
		prom.measure = self
		return prom
	}
	
	func measureIdentifier() -> String {
		return loinc ?? OID
	}
	
}

extension EASIPRO.SessionController2 {
	
	open func prepareSessionContainer(callback: @escaping ((UIViewController?, Error?) -> Void)) {
        
        guard let measures = measures else {
            print("Abort prepareSession")
            return
        }
		
		let acForms = measures.map { (m) -> ACForm? in
			if let ac_coding = m.prescribingResource?.ep_coding(for: "http://www.assessmentcenter.net") {
				let form = ACForm(_oid: ac_coding.code!.string, _title: ac_coding.display!.string, _loinc: nil)
				m.measure = form as AnyObject
				return form
			}
			return nil
			}.flatMap { $0 }
		
		

        
        let acclient = ACClient.NewClient()
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


extension EASIPRO.SessionController2 : ACTaskViewControllerDelegate {
    
    public func assessmentViewController(_ taskViewController: ACTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?, tscore: Double?, stderror: Double?, session: SessionItem) {
        
        let acform = (taskViewController.task as! ACTask).form
        if reason == .completed { handleCompletion(for: acform, session: session) }
    }
    
    public func didDismissACTaskViewController() {
        
    }
    
    func handleCompletion(for form: ACForm, session: SessionItem) {
        
//        let measure = measures?.filter({ (m) -> Bool in
//            return (m.identifier == form.OID || m.identifier == form.loinc)
//        }).first
//         TODO: standardize a measureId for ACForm.
        
//        print(measures?.first?.measure)
        guard let procedureRequest = measures?.first?.prescribingResource else {
            print("abort, no matching procedure request")
            return
        }
        var qr = form.as_FHIRQuestionnaireResponse(with: session.score)!
        
        qr["subject"] = ["reference": "Patient/\(patient.id!.string)"]
        qr["authored"] = FHIRDate.today.description
        qr["basedOn"]  = [["reference": "ProcedureRequest/\(procedureRequest.id!.string)"]]
        
        // todo: change to today
        do {
            let qResponse = try QuestionnaireResponse(json: qr)
            let srv = SMARTManager.shared.client.server
            qResponse.createAndReturn(srv, callback: { [weak self] (ferror) in
                let qResponseId = qResponse.id!.string
                var observation = form.as_FHIRObservation(with: session.score!, related: qResponseId, subject: self?.patient.id!.string)
                if let basedOnReference = qResponse.basedOn?.first?.reference?.string {
                    observation!["basedOn"] = [["reference" : basedOnReference]]
                }
                do {
                    let observationFHIR = try Observation(json: observation!)
                    observationFHIR.createAndReturn(SMARTManager.shared.client.server, callback: { (error) in
                        print("Observation:", observationFHIR.id?.string as Any)
						self?.onMeasureCompletion?(observationFHIR, form.proMeasure())
                    })
                }
                catch {
                    print(error)
                }
            })
        }
        catch { //do
            print(error.localizedDescription)
        }
    }
}


extension ProcedureRequest {
	
	public func ep_AssessmentCenterCode() -> String? {
		return ep_coding(for: "http://www.assessmentcenter.net")?.code?.string
	}
}
