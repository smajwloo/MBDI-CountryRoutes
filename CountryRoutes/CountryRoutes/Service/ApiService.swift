import SwiftUI

class ApiService: ObservableObject {
    private let urlString = "https://restcountries.com/v3.1/all"
    
    @Published var countryList = [Country]()
    
    func fetchApiData(dispatchGroup: DispatchGroup) {
        guard let url = URL(string: urlString) else {
            print("ERROR: failed to construct a URL from string")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            var countries: [Country]?
            
            if let error = error {
                print("ERROR: fetch failed \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("ERROR: failed to get data from URLSession")
                return
            }
            
            countries = self.decodeData(data: data)
            
            guard let countries = countries else {
                print("ERROR: failed to read or decode data.")
                return
            }
            
            DispatchQueue.main.async {
                self.countryList = countries
                dispatchGroup.leave()
            }
        }
        task.resume()
    }
    
    func decodeData(data: Data) -> [Country] {
        do {
            return try JSONDecoder().decode([Country].self, from: data)
        } catch let error as NSError {
            print("ERROR: decoding. In domain= \(error.domain), desciption= \(error.localizedDescription)")
        } catch DecodingError.keyNotFound(let key, let context) {
            print("ERROR: could not find key \(key) in JSON \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("ERROR: could not find type \(type) in JSON \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("ERROR: type mismatch for type \(type) in JSON \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            print("ERROR: data found to be corrupted in JSON \(context.debugDescription)")
        } catch {
            print("ERROR: an unknown error occured \(error)")
        }
        return []
    }
}
