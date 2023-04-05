import SwiftUI

struct CountryImageView: View {
    var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image.resizable()
            } else {
                ProgressView()
            }
        }
    }
    
}
// swiftlint:disable vertical_whitespace





















struct CountryImageView_Previews: PreviewProvider {
    static var previews: some View {
        CountryImageView(url: defaultCountries[0].flags.png)
    }
}
// swiftlint:enable vertical_whitespace
