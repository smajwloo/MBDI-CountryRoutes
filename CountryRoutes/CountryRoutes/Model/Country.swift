import SwiftUI

struct Country: Codable {
    var name: Name
    var status: String
    var unMember: Bool
    var region: String
    var latlng: [Double]
    var landlocked: Bool
    var area: Float64?
    var population: Int?
    var flags: Flags
}

struct Name: Codable {
    var common: String
    var official: String
}

struct Flags: Codable {
    var png: String
}
// swiftlint:disable vertical_whitespace






















var defaultCountries = [
    Country(name: Name(common: "Netherlands", official: "Kingdom of the Netherlands"),
            status: "officially-assigned",
            unMember: true,
            region: "Europe",
            latlng: [52.5, 5.75],
            landlocked: false,
            area: 41850.0,
            population: 16655799,
            flags: Flags(png: "https://flagcdn.com/w320/nl.png")),
    
    Country(name: Name(common: "Belgium", official: "Kingdom of Belgium"),
            status: "officially-assigned",
            unMember: true,
            region: "Europe",
            latlng: [50.83333333, 4.0],
            landlocked: false,
            area: 30528.0,
            population: 11555997,
            flags: Flags(png: "https://flagcdn.com/w320/be.png"))
]
// swiftlint:enable vertical_whitespace
