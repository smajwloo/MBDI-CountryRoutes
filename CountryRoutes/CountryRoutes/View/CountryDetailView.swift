import SwiftUI
import MapKit

struct CountryDetailView: View {
    let filenamePrefix = "edited_country_"
    let mapHeight = 250.0
    let imagePaddingTop = -100.0
    
    @State var country: Country
    
    func initView() {
        do {
            let filename = filenamePrefix + country.name.official
            let documentDirectory = getDocumentDirectory()
            
            guard let documentDirectory = documentDirectory else { return }
            guard FileManager.default.fileExists(atPath: documentDirectory.path() + filename) else { return }

            let fileURL = documentDirectory.appendingPathComponent(filename)
            let countryData = try Data(contentsOf: fileURL)
            country = try JSONDecoder().decode(Country.self, from: countryData)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("ERROR: could not find key \(key) in JSON \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("ERROR: could not find type \(type) in JSON \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("ERROR: type mismatch for type \(type) in JSON \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            print("ERROR: data found to be corrupted in JSON \(context.debugDescription)")
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(destination: CountryEditorView(country: $country)) {
                    Text("Edit country details")
                }
                mapView
                countryImage
                countryInformation
            } // VStack
        } // ScrollView
        .onAppear(perform: initView)
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
    
    var countryInformation: some View {
        VStack(alignment: .leading) {
            Text("Official name: \(country.name.official)").font(.title3)

            Divider()
            
            Text("Area: \(formatFloat(number: country.area)) km²").font(.headline)
            Text("Population: \(country.population ?? 0)").font(.headline)
            
            Divider()
            
            Text("Region: \(country.region)")
            Text("Status: \(country.status)")
            Text("Member of the UN: \(convertBoolToText(bool: country.unMember))")
            Text("Land is locked: \(convertBoolToText(bool: country.landlocked))")
        }.padding()
    }
    
    var mapView: some View {
        MapView(region: MKCoordinateRegion(
                        center: generateCLLLocation(country: country),
                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
        .frame(height: mapHeight)
        .cornerRadius(20)
    }
    
    var countryImage: some View {
        CountryImageView(url: country.flags.png)
            .clipShape(Rectangle())
            .overlay(Rectangle().stroke(.white, lineWidth: 4))
            .shadow(radius: 7)
            .scaledToFit()
            .frame(height: 150)
            .frame(maxWidth: 250)
            .padding(.top, imagePaddingTop)
    }
    
    func formatFloat(number: Float64?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3

        let nsNumber = NSNumber(value: number ?? 0.0)
        return formatter.string(from: nsNumber) ?? ""
    }
    
    func generateCLLLocation(country: Country) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(country.latlng[0]),
                                      longitude: CLLocationDegrees(country.latlng[1]))
    }
    
    func convertBoolToText(bool: Bool) -> String {
        if bool {
            return "Yes"
        }
        return "No"
    }
    
    func getDocumentDirectory() -> URL? {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch CocoaError.fileNoSuchFile {
            print("ERROR: no such file exists")
        } catch CocoaError.fileReadNoPermission {
            print("ERROR: no permissions to read file")
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        return nil
    }
}
// swiftlint:disable vertical_whitespace























struct CountryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailView(country: defaultCountries[0])
    }
}
// swiftlint:enable vertical_whitespace
