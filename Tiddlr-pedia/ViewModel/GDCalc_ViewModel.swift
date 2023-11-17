//
//  GDCalc_ViewModel.swift
//  Tiddlr-pedia
//
//  Created by Renzo Sy on 11/17/23.
//

import SwiftUI
import Combine

class GDCalc_ViewModel: ObservableObject {
    @Published var weight: String = ""
    @Published var selectedMedication: Medication?
    @Published var minDosage: String = ""
    @Published var maxDosage: String = ""
    @Published var frequency: String = "1"
    @Published var calculationType: DosageCalculationType = .perDose
    @Published var administrationRoute: AdministrationRoute = .oral
    @Published var medicationForm: MedicationForm = .solid
    @Published var preparationMg: String = ""
    @Published var preparationMl: String = ""

    var medications: [Medication] = [
        Medication(name: "Paracetamol", dosageRange: (10, 15), defaultCalculationType: .perDose),
        Medication(name: "Amoxicillin", dosageRange: (40, 60), defaultCalculationType: .perDay),
        Medication(name: "Ampicillin", dosageRange: (200, 400), defaultCalculationType: .perDay)
        // Add more medications as needed
    ]

    var gdRange: (min: Double, max: Double)? {
        // Ensure all values are valid doubles and the weight is not zero
        guard let weightValue = Double(weight),
              let minDosageValue = Double(minDosage),
              let maxDosageValue = Double(maxDosage),
              !weightValue.isZero else { return nil }

        let frequencyValue = Double(frequency) ?? 1
        let preparationValue = medicationForm == .solid ? Double(preparationMg) ?? 1 : (Double(preparationMg) ?? 1) / (Double(preparationMl) ?? 1)
        let minGD: Double
        let maxGD: Double

        // Use the appropriate formula based on the administration route
        if administrationRoute == .oral {
            minGD = (minDosageValue * weightValue * (1 / preparationValue)) / frequencyValue
            maxGD = (maxDosageValue * weightValue * (1 / preparationValue)) / frequencyValue
        } else { // For .intravenous or other routes
            minGD = (minDosageValue * weightValue) / frequencyValue
            maxGD = (maxDosageValue * weightValue) / frequencyValue
        }

        return (minGD, maxGD)
    }

    func updateDosageRange(to newMedication: Medication?) {
        guard let newMedication = newMedication else { return }
        minDosage = String(format: "%.2f", newMedication.dosageRange.min)
        maxDosage = String(format: "%.2f", newMedication.dosageRange.max)
    }
}
