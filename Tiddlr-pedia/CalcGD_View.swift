import SwiftUI

enum DosageCalculationType: String, CaseIterable, Identifiable, Hashable {
    case perDay = "mg/kg/day"
    case perDose = "mg/kg/dose"
    
    var id: String { self.rawValue }
}

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

struct CalcGD_View: View {
    @State private var weight: String = ""
    @State private var selectedMedication: Medication?
    @State private var minDosage: String = ""
    @State private var maxDosage: String = ""
    @State private var frequency: String = "1"
    @State private var calculationType: DosageCalculationType = .perDose
    @State private var administrationRoute: AdministrationRoute = .oral
    @State private var medicationForm: MedicationForm = .solid
    @State private var preparationMg: String = "" // For solid form
    @State private var preparationMl: String = "" // For liquid form


    
    let medications: [Medication] = [
        Medication(name: "Paracetamol", dosageRange: (10, 15), defaultCalculationType: .perDose),
        Medication(name: "Amoxicillin", dosageRange: (40, 60), defaultCalculationType: .perDay),
        Medication(name: "Ampicillin", dosageRange: (200, 400), defaultCalculationType: .perDay),
        // Add more medications as needed
    ]
    
    private var gdRange: (min: Double, max: Double)? {
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
    
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Given Dose Range")) {
                    HStack {
                        Text("Min GD: ")
                        Spacer()
                        // Display the calculated value or placeholder
                        Text(gdRange != nil ? "\(gdRange!.min, specifier: "%.2f")" : "--")
                            .foregroundColor(gdRange != nil ? .primary : .secondary)
                            .padding(.trailing, 10)
                        Text(calculationType == .perDay ? "mg/kg/day" : "mg/kg/dose")
                            .padding(.trailing, 10)
                    }
                    
                    HStack {
                        Text("Max GD: ")
                        Spacer()
                        // Display the calculated value or placeholder
                        Text(gdRange != nil ? "\(gdRange!.max, specifier: "%.2f")" : "--")
                            .foregroundColor(gdRange != nil ? .primary : .secondary)
                            .padding(.trailing, 10)
                        Text(calculationType == .perDay ? "mg/kg/day" : "mg/kg/dose")
                            .padding(.trailing, 10)
                    }
                }
                
                Section(header: Text("Medication")) {
                    Picker("Select Medication", selection: $selectedMedication) {
                        ForEach(medications, id: \.self) { medication in
                            Text(medication.name).tag(medication as Medication?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedMedication) { newValue in
                        if let newMedication = newValue {
                            calculationType = newMedication.defaultCalculationType
                            updateDosageRange(to: newMedication)
                        }
                    }
                    Picker("Dosage Calculation Type", selection: $calculationType) {
                        ForEach(DosageCalculationType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Picker("Administration Route", selection: $administrationRoute) {
                        ForEach(AdministrationRoute.allCases) { route in
                            Text(route.rawValue).tag(route)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if administrationRoute == .oral {
                        Picker("Form", selection: $medicationForm) {
                            ForEach(MedicationForm.allCases) { form in
                                Text(form.rawValue).tag(form)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        if medicationForm == .liquid {
                            TextField("mg", text: $preparationMg)
                                .keyboardType(.decimalPad)
                            TextField("mL", text: $preparationMl)
                                .keyboardType(.decimalPad)
                        } else {
                            TextField("mg", text: $preparationMg)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                
                Section(header: Text("Recommended Dosage")) {
                    TextField("Min Dosage", text: $minDosage)
                        .keyboardType(.decimalPad)
                        .overlay(
                            HStack {
                                Spacer()
                                Text(calculationType == .perDay ? "mg/kg/day" : "mg/kg/dose")
                                    .padding(.trailing, 10)
                            }, alignment: .trailing
                        )
                    
                    TextField("Max Dosage", text: $maxDosage)
                        .keyboardType(.decimalPad)
                        .overlay(
                            HStack {
                                Spacer()
                                Text(calculationType == .perDay ? "mg/kg/day" : "mg/kg/dose")
                                    .padding(.trailing, 10)
                            }, alignment: .trailing
                        )
                }
                
                Section(header: Text("Patient Information")) {
                    TextField("Weight", text: $weight)
                        .keyboardType(.decimalPad)
                        .overlay(
                            HStack {
                                Spacer()
                                Text("kg")
                                    .padding(.trailing, 10)
                            }, alignment: .trailing
                        )
                    
                    if calculationType == .perDay {
                        TextField("Frequency", text: $frequency)
                            .keyboardType(.numberPad)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Text("doses/day")
                                        .padding(.trailing, 10)
                                }, alignment: .trailing
                            )
                    }
                }
                
                // Additional sections for preparation concentration and volume can be added here
            }
            .navigationTitle("Dosage Calculator")
        }
    }
    
    private func updateDosageRange(to newMedication: Medication?) {
        guard let newMedication = newMedication else { return }
        minDosage = String(format: "%.2f", newMedication.dosageRange.min)
        maxDosage = String(format: "%.2f", newMedication.dosageRange.max)
    }
    
    
    
    
}

extension View {
    @ViewBuilder func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct CalcGDView_Previews: PreviewProvider {
    static var previews: some View {
        CalcGD_View()
    }
}
