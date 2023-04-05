import SwiftUI

struct CountryEditorView: View {
    let filenamePrefix = "edited_country_"
    
    @Environment(\.dismiss) var dismiss
    @Binding var country: Country
    
    var body: some View {
        NavigationView {
            Form {
                numeralFieldsSection
                textFieldsSection
                togglesSection
                saveButton
            } // Form
        } // NavigationView
        .navigationTitle(country.name.official)
        .navigationBarTitleDisplayMode(.large)
    }
    
    var numeralFieldsSection: some View {
        Section("Numeral") {
            LabeledContent {
                TextField("Enter area in km²", value: $country.area, format: .number)
                    .keyboardType(.numbersAndPunctuation)
            } label: {
                Text("Area in km²:")
            }
            LabeledContent {
                TextField("Enter population", value: $country.population, format: .number)
                    .keyboardType(.numbersAndPunctuation)
            } label: {
                Text("Population:")
            }
        }
    }
    
    var textFieldsSection: some View {
        Section("Text") {
            LabeledContent {
                TextField("Enter region", text: $country.region)
            } label: {
                Text("Region:")
            }
            LabeledContent {
                TextField("Enter status", text: $country.status)
            } label: {
                Text("Status:")
            }
        }
    }
    
    var togglesSection: some View {
        Section("Yes or no") {
            HStack {
                Text("UN member:")
                Spacer()
                Toggle(isOn: $country.unMember, label: {
                    Text(convertBoolToText(bool: country.unMember))
                })
                .toggleStyle(.button)
                .buttonStyle(.borderedProminent)
            }
            HStack {
                Text("Land is locked:")
                Spacer()
                Toggle(isOn: $country.landlocked, label: {
                    Text(convertBoolToText(bool: country.landlocked))
                })
                .toggleStyle(.button)
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            saveCountryState(country: country)
            dismiss()
        }, label: {
            Text("Save")
        })
    }
    
    func convertBoolToText(bool: Bool) -> String {
        if bool {
            return "Yes"
        }
        return "No"
    }
        
    func saveCountryState(country: Country) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let countryData = try encoder.encode(country)
            save(countryData: countryData)
        } catch {
            print(error)
        }
    }
    
    func save(countryData: Data) {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            
            let filename = filenamePrefix + country.name.official
            let fileURL = documentDirectory.appendingPathComponent(filename)
            try countryData.write(to: fileURL)
        } catch CocoaError.fileNoSuchFile {
            print("ERROR: no such file exists")
        } catch CocoaError.fileReadNoPermission {
            print("ERROR: no permissions to read file")
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
// swiftlint:disable vertical_whitespace






















struct CountryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CountryEditorView(country: .constant(defaultCountries[0]))
    }
}
// swiftlint:enable vertical_whitespace
