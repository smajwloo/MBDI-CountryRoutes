import SwiftUI
import MapKit

struct MapView: View {
    @State var region = MKCoordinateRegion()

    var body: some View {
        Map(coordinateRegion: $region)
    }
}
// swiftlint:disable vertical_whitespace
























struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.688521, longitude: 5.286698),
            span: MKCoordinateSpan(
                latitudeDelta: 0.5,
                longitudeDelta: 0.5)
            ))
    }
}
// swiftlint:enable vertical_whitespace
