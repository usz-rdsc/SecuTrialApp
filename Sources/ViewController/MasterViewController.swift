//
//  MasterViewController.swift
//  SecuTrialApp
//
//  Created by Pascal Pfiffner on 08/10/15.
//  Copyright © 2015 USZ. All rights reserved.
//

import UIKit
import SecuTrialClient


class MasterViewController: UITableViewController {
	
	var client: SecuTrialClient? {
		didSet {
			if let projectname = client?.formDefinition?.projectname, let modelname = client?.formDefinition?.modelname {
				title = "\(projectname) – \(modelname)"
			}
			if isViewLoaded {
				tableView.reloadData()
			}
		}
	}
	
	var detailViewController: DetailViewController? = nil
	
	
	override func viewWillAppear(_ animated: Bool) {
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}
	
	
	// MARK: - Segues
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			if let indexPath = self.tableView.indexPathForSelectedRow {
				let form = client!.forms![indexPath.section]
				let format = form.importFormats[indexPath.row]
				let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
				controller.form = form
				controller.importFormat = format
				controller.title = format.formatName
				controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
				controller.navigationItem.leftItemsSupplementBackButton = true
			}
		}
	}
	
	
	// MARK: - Table View
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return client?.forms?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let form = client!.forms![section]
		return form.formname ?? form.formtablename ?? "Unnamed Form".secu_loc
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return client!.forms![section].importFormats.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		let format = client!.forms![indexPath.section].importFormats[indexPath.row]
		cell.textLabel!.text = format.formatName ?? "Unnamed Import Format".secu_loc
		return cell
	}
}

