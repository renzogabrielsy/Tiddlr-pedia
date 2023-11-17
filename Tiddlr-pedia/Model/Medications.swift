//
//  Medications.swift
//  Tiddlr-pedia
//
//  Created by Renzo Sy on 11/17/23.
//

import Foundation

struct Medication: Identifiable {
    let id = UUID()
    var name: String
    var dosageRange: (min: Double, max: Double)
    var defaultCalculationType: DosageCalculationType
}

// Manually conform to Equatable
extension Medication: Equatable {
    static func == (lhs: Medication, rhs: Medication) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.dosageRange.min == rhs.dosageRange.min &&
        lhs.dosageRange.max == rhs.dosageRange.max &&
        lhs.defaultCalculationType == rhs.defaultCalculationType
    }
}

// Manually conform to Hashable
extension Medication: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(dosageRange.min)
        hasher.combine(dosageRange.max)
        hasher.combine(defaultCalculationType)
    }
}
