import SwiftUI

struct ContentView: View {
    let filename = "deleted_countries"
    
    @StateObject var apiService = ApiService()
    @State var deletedCountryList: [String]?
    
    /// update data with locally stored data, by excluding previously deleted countries
    func initView() {
        deletedCountryList = receiveDeletedCountryList()
        
        guard let deletedCountries = deletedCountryList else {
            return
        }

        apiService.countryList = apiService.countryList.filter { country in
            !deletedCountries.contains(country.name.official)
            
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(apiService.countryList, id: \Country.name.official) { country in
                    NavigationLink(destination: CountryDetailView(country: country)) {
                        CountryRow(country: country)
                    }
                } // ForEach
                .onDelete(perform: deleteCountry)
            } // List
            .onAppear(perform: gatherData)
            .navigationBarTitle("Countries")
            .toolbar {
                EditButton()
            }
        } // NavigationView
    }
    
    func gatherData() {
        let group = DispatchGroup()
        group.enter()
        
        apiService.fetchApiData(dispatchGroup: group)
        
        group.notify(queue: .main) {
            initView()
        }
    }
    
    func deleteCountry(at offsets: IndexSet) {
        offsets.forEach { offset in
            let country = apiService.countryList[offset]
            deletedCountryList?.append(country.name.official)
        }
        
        apiService.countryList.remove(atOffsets: offsets)
        saveDeletedCountryList(deletedCountryList: deletedCountryList)
    }
    
    func receiveDeletedCountryList() -> [String] {
        do {
            let documentDirectory = getDocumentDirectory()
            
            guard let documentDirectory = documentDirectory else { return [] }
            guard FileManager.default.fileExists(atPath: documentDirectory.path() + filename) else { return [] }
            
            let fileURL = documentDirectory.appendingPathComponent(filename)
            let deletedCountriesData = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([String].self, from: deletedCountriesData)
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
        return []
    }
    
    func saveDeletedCountryList(deletedCountryList: [String]?) {
        guard let deletedCountries = deletedCountryList else { return }
        
        do {
            let deletedCountryListData = try JSONEncoder().encode(deletedCountries)
            save(deletedCountryListData: deletedCountryListData)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func save(deletedCountryListData: Data) {
        do {
            let documentDirectory = getDocumentDirectory()
            
            guard let documentDirectory = documentDirectory else {
                return
            }
            
            let fileURL = documentDirectory.appendingPathComponent(filename)
            try deletedCountryListData.write(to: fileURL)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
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






















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
// swiftlint:enable vertical_whitespace
