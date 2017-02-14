//
//  String+Localize.swift
//  SecuTrialApp
//
//  Created by Pascal Pfiffner on 11.02.17.
//  Copyright © 2017 USZ. All rights reserved.
//

import Foundation


extension String {
	
	public var secu_loc: String {
		return NSLocalizedString(self, comment: "")
	}
}

