//
//  AppError.swift
//  SecuTrialApp
//
//  Created by Pascal Pfiffner on 11.02.17.
//  Copyright © 2017 USZ. All rights reserved.
//


enum AppError: Error, CustomStringConvertible {
	case noSurveyForm
	case noSurveyImportFormat
	
	public var description: String {
		switch self {
		case .noSurveyForm:         return "No form, cannot start survey"
		case .noSurveyImportFormat: return "No import format, cannot start survey"
		}
	}
}
