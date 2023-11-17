import SwiftUI

struct CalcGD_View: View {
    @StateObject var viewModel = GDCalc_ViewModel()
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Given Dose Range")) {
                    HStack {
                        Text("Min GD: ")
                        Spacer()
                        // Display the calculated value or placeholder
                        Text(viewModel.gdRange != nil ? "\(viewModel.gdRange!.min, specifier: "%.2f")" : "--")
                            .foregroundColor(viewModel.gdRange != nil ? .primary : .secondary)
                            .padding(.trailing, 10)
                        Text(viewModel.medicationForm == .solid ? "mg/dose" : "mL/dose")
                            .padding(.trailing, 10)
                    }
                    
                    HStack {
                        Text("Max GD: ")
                        Spacer()
                        // Display the calculated value or placeholder
                        Text(viewModel.gdRange != nil ? "\(viewModel.gdRange!.max, specifier: "%.2f")" : "--")
                            .foregroundColor(viewModel.gdRange != nil ? .primary : .secondary)
                            .padding(.trailing, 10)
                        Text(viewModel.medicationForm == .solid ? "mg/dose" : "mL/dose")
                            .padding(.trailing, 10)
                    }
                }
                
                Section(header: Text("Medication")) {
                    Picker("Select Medication", selection: $viewModel.selectedMedication) {
                        ForEach(viewModel.medications, id: \.self) { medication in
                            Text(medication.name).tag(medication as Medication?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: viewModel.selectedMedication) { newValue in
                        if let newMedication = newValue {
                            viewModel.calculationType = newMedication.defaultCalculationType
                            viewModel.updateDosageRange(to: newMedication)
                        }
                    }
                    Picker("Dosage Calculation Type", selection: $viewModel.calculationType) {
                        ForEach(DosageCalculationType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Picker("Administration Route", selection: $viewModel.administrationRoute) {
                        ForEach(AdministrationRoute.allCases) { route in
                            Text(route.rawValue).tag(route)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if viewModel.administrationRoute == .oral {
                        Picker("Form", selection: $viewModel.medicationForm) {
                            ForEach(MedicationForm.allCases) { form in
                                Text(form.rawValue).tag(form)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        if viewModel.medicationForm == .liquid {
                            TextField("", text: $viewModel.preparationMg)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Text("mg")
                                            .padding(.trailing, 10)
                                    }, alignment: .trailing
                                )
                            TextField("--", text: $viewModel.preparationMl)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Text("mL")
                                            .padding(.trailing, 10)
                                    }, alignment: .trailing
                                )
                            
                        } else {
                            TextField("--", text: $viewModel.preparationMg)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Text("mg")
                                            .padding(.trailing, 10)
                                    }, alignment: .trailing
                                )
                                
                        }
                    }
                }
                
                Section(header: Text("Recommended Dosage")) {
                    TextField("Min Dosage", text: $viewModel.minDosage)
                        .keyboardType(.decimalPad)
                        .overlay(
                            HStack {
                                Spacer()
                                Text(viewModel.calculationType == .perDay ? "mg/kg/day" : "mg/kg/dose")
                                    .padding(.trailing, 10)
                            }, alignment: .trailing
                        )
                    
                    TextField("Max Dosage", text: $viewModel.maxDosage)
                        .keyboardType(.decimalPad)
                        .overlay(
                            HStack {
                                Spacer()
                                Text(viewModel.calculationType == .perDay ? "mg/kg/day" : "mg/kg/dose")
                                    .padding(.trailing, 10)
                            }, alignment: .trailing
                        )
                }
                
                Section(header: Text("Patient Information")) {
                    TextField("Weight", text: $viewModel.weight)
                        .keyboardType(.decimalPad)
                        .overlay(
                            HStack {
                                Spacer()
                                Text("kg")
                                    .padding(.trailing, 10)
                            }, alignment: .trailing
                        )
                    
                    if viewModel.calculationType == .perDay {
                        TextField("Frequency", text: $viewModel.frequency)
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
