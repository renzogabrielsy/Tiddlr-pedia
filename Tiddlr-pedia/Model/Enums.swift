//
//  Enums.swift
//  Tiddlr-pedia
//
//  Created by Renzo Sy on 11/17/23.
//

import Foundation

enum DosageCalculationType: String, CaseIterable, Identifiable, Hashable {
    case perDay = "mg/kg/Day"
    case perDose = "mg/kg/dose"
    
    var id: String { self.rawValue }
}

enum AdministrationRoute: String, CaseIterable, Identifiable {
    case oral = "Oral"
    case intravenous = "Intravenous"
    
    var id: String { self.rawValue }
}

enum MedicationForm: String, CaseIterable, Identifiable {
    case solid = "Solid"
    case liquid = "Liquid"

    var id: String { self.rawValue }
}
