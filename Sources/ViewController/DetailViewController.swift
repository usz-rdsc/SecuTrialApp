//
//  DetailViewController.swift
//  SecuTrialApp
//
//  Created by Pascal Pfiffner on 08/10/15.
//  Copyright © 2015 USZ. All rights reserved.
//

import UIKit
import SecuTrialClient


class DetailViewController: UIViewController {
	
	@IBOutlet weak var detailDescriptionLabel: UILabel!
	
	/// The client in use.
	var client: SecuTrialClient?
	
	/// The form to handle.
	var form: SecuTrialEntityForm?
	
	var importFormat: SecuTrialEntityImportFormat? {
		didSet {
		    // Update the view.
		    self.configureView()
		}
	}
	
	/// The survey, if one is currently being presented.
	var survey: SecuTrialSurvey?
	
	func configureView() {
		if let detail = importFormat {
		    if let label = self.detailDescriptionLabel {
		        label.text = "\(detail)"
		    }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureView()
	}
	
	@IBAction func startSurvey() {
		do {
			guard let form = form else {
				throw AppError.noSurveyForm
			}
			guard let importFormat = importFormat else {
				throw AppError.noSurveyImportFormat
			}
			
			survey = SecuTrialSurvey(form: form, importFormat: importFormat)
			let vc = try survey!.taskViewController(
				complete: { viewController, response in
					
					// finish response record
					response.project = self.client?.formDefinition?.modelname
//					response.centre = "Zentrum FDTS 1"
					
					print("it worked! \(response.node("root").asXMLString())")
					viewController.dismiss(animated: true)
				},
				failure: { viewController, error in
					print("it failed: \(error)")
					viewController.dismiss(animated: true)
				}
			)
			present(vc, animated: true)
		}
		catch let error {
			alert(error: error)
		}
	}
	
	// MARK: - Alert
	
	func alert(error: Error, title: String = "Error".secu_loc) {
		let alert = UIAlertController(title: title, message: "\(error)", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK".secu_loc, style: .default, handler: nil))
		if nil != presentedViewController {
			dismiss(animated: true) {
				self.present(alert, animated: true)
			}
		}
		else {
			present(alert, animated: true)
		}
	}
}

