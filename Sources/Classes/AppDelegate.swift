//
//  AppDelegate.swift
//  SecuTrialApp
//
//  Created by Pascal Pfiffner on 08/10/15.
//  Copyright © 2015 USZ. All rights reserved.
//

import UIKit
import SecuTrialClient


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
	
	var window: UIWindow?
	
	var client: SecuTrialClient!
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// initialize client
		let url = URL(string: cSecuTrialEndpoint)!
		client = SecuTrialClient(url: url, customer: cSecuTrialCustomer, username: cSecuTrialUsername, password: cSecuTrialPassword)
		try! client.readFormsFromSpecificationFile("VisitForm")
		//--
//		test(client)
		//--
		
		// Override point for customization after application launch.
		let splitViewController = self.window!.rootViewController as! UISplitViewController
		let listController = (splitViewController.viewControllers[0] as! UINavigationController).topViewController! as! MasterViewController
		listController.client = client
		let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
		navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		splitViewController.delegate = self
		
		return true
	}
	
	
	func test(_ client: SecuTrialClient) {
		let patient = SecuTrialBeanPatient()
		patient.aid = "FDTS001"
		
		let visit = SecuTrialBeanVisit()
		visit.date = "30.10.2015 16:00"
		
		let items = [
			SecuTrialBeanFormDataItem(key: "zahl", value: "78.2"),
			SecuTrialBeanFormDataItem(key: "text", value: "Hello"),
			SecuTrialBeanFormDataItem(key: "dtm", value: "30.10.2015 16:08"),
			SecuTrialBeanFormDataItem(key: "rb", value: "0"),
			SecuTrialBeanFormDataItem(key: "cb", value: "1"),
		]
		
		let data = SecuTrialBeanFormDataRecord()
		data.project = "CTP17"
		data.centre = "Zentrum FDTS 1"
		data.form = "vis"
		data.patient = patient
		data.visit = visit
		data.item = items
		
		let ops = SecuTrialOperation(name: "transmit")
		ops.addInput(SecuTrialOperationInput(name: "datarecord", bean: data))
		ops.expectedResponseBean = SecuTrialBeanWebServiceResult.self
		ops.expectsResponseBeanAt = ["transmitResponse", "transmitReturn"]
		
		client.performOperation(ops) { response in
			if let error = response.error {
				DispatchQueue.main.async() {
					let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					self.window?.rootViewController?.present(alert, animated: true)
				}
			}
			//print("\n\n\(response.envelope.asXMLString())")
		}
	}
	
	
	// MARK: - Split view
	
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
	    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
	    guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
	    if topAsDetailController.importFormat == nil {
	        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
	        return true
	    }
	    return false
	}
}

