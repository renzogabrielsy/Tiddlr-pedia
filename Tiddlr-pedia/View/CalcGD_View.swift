import SwiftUI

struct CalcGD_View: View {
    @StateObject var viewModel = GDCalc_ViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Given Dose Range")) {
                    HStack {
                        if viewModel.administrationRoute == .intravenous {
                            Image(systemName: "ivfluid.bag")
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 24, weight: .regular))
                                .foregroundStyle(.mint, .gray)
                        } else {
                            if viewModel.medicationForm == .liquid {
                                Image(systemName: "ivfluid.bag")
                                    .symbolRenderingMode(.palette)
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundStyle(.mint, .gray)
                            } else {
                                Image(systemName: "pills.circle")
                                    .symbolRenderingMode(.palette)
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundStyle(.mint, .gray)
                            }
                        }
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
                        if viewModel.administrationRoute == .intravenous {
                            Image(systemName: "ivfluid.bag.fill")
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 24, weight: .regular))
                                .foregroundStyle(.mint, .gray)
                        } else {
                            if viewModel.medicationForm == .liquid {
                                Image(systemName: "ivfluid.bag.fill")
                                    .symbolRenderingMode(.palette)
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundStyle(.mint, .gray)
                            } else {
                                Image(systemName: "pills.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundStyle(.mint, .gray)
                            }
                            
                        }
                        
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
                
                Section(header: Text("Recommended Dosage")) {
                    HStack{
                        Image(systemName: "staroflife")
                            .symbolRenderingMode(.palette)
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(.red)
                        TextField("Min Dosage", text: $viewModel.minDosage)
                            .keyboardType(.decimalPad)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Text(viewModel.calculationType == .perDay ? "mg/kg/Day" : "mg/kg/dose")
                                        .padding(.trailing, 10)
                                }, alignment: .trailing
                            )
                    }
                    
                    HStack{
                        Image(systemName: "staroflife.fill")
                            .symbolRenderingMode(.palette)
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(.red)
                        TextField("Max Dosage", text: $viewModel.maxDosage)
                            .keyboardType(.decimalPad)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Text(viewModel.calculationType == .perDay ? "mg/kg/Day" : "mg/kg/dose")
                                        .padding(.trailing, 10)
                                }, alignment: .trailing
                            )
                    }
                }
                
                Section(header: Text("Medication")) {
                    HStack{
                        Image(systemName: "vial.viewfinder")
                            .symbolRenderingMode(.palette)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.mint, .gray)
                        Picker("Select Medication", selection: $viewModel.selectedMedication) {
                            ForEach(viewModel.medications, id: \.self) { medication in
                                Text(medication.name).tag(medication as Medication?)
                            }
                        }
                        .padding(.leading, 5)
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: viewModel.selectedMedication) { newValue in
                            if let newMedication = newValue {
                                viewModel.calculationType = newMedication.defaultCalculationType
                                viewModel.updateDosageRange(to: newMedication)
                            }
                        }
                    }
                    
                    VStack{
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
                        }
                        HStack{
                            if viewModel.medicationForm == .liquid {
                                HStack{
                                    Image(systemName: "pill.circle")
                                        .symbolRenderingMode(.palette)
                                        .font(.system(size: 20, weight: .regular))
                                        .foregroundStyle(.mint, .gray)
                                    TextField("--", text: $viewModel.preparationMg)
                                        .keyboardType(.decimalPad)
                                        .overlay(
                                            HStack {
                                                Spacer()
                                                Text("mg")
                                                    .padding(.trailing, 10)
                                            }, alignment: .trailing
                                        )
                                    Image(systemName: "cross.vial.fill")
                                        .symbolRenderingMode(.palette)
                                        .font(.system(size: 20, weight: .regular))
                                        .foregroundStyle(.mint, .gray)
                                    TextField("--", text: $viewModel.preparationMl)
                                        .keyboardType(.decimalPad)
                                        .overlay(
                                            HStack {
                                                Spacer()
                                                Text("mL")
                                                    .padding(.trailing, 10)
                                            }, alignment: .trailing
                                        )
                                }
                                .padding(.top, 10)
                                
                            } else {
                                HStack{
                                    Image(systemName: "pill.circle")
                                        .symbolRenderingMode(.palette)
                                        .font(.system(size: 23, weight: .regular))
                                        .foregroundStyle(.mint, .gray)
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
                                .padding(.top, 10)
                                
                                
                                
                            }
                        }
                        
                        
                        
                    }
                }
                
                
                Section(header: Text("Patient Information")) {
                    HStack{
                        Image(systemName: "scalemass.fill")
                            .symbolRenderingMode(.palette)
                            .font(.system(size: 23, weight: .regular))
                            .foregroundStyle(.mint, .gray)
                        TextField("Weight", text: $viewModel.weight)
                            .keyboardType(.decimalPad)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Text("kg")
                                        .padding(.trailing, 10)
                                }, alignment: .trailing
                            )
                        
                    }
                    
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
            .navigationTitle(
                Text("GD Calculator")
            )
            .accentColor(.mint)
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
