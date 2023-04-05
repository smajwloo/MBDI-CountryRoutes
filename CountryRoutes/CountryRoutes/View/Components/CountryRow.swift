import SwiftUI

struct CountryRow: View {
    @State var country: Country
    
    var body: some View {
        HStack {
            CountryImageView(url: country.flags.png)
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text(country.name.common)
        } // HStack
    }
}
// swiftlint:disable vertical_whitespace























struct CountryRow_Previews: PreviewProvider {
    static var previews: some View {
        CountryRow(country: defaultCountries[0])
    }
}
// swiftlint:enable vertical_whitespace
