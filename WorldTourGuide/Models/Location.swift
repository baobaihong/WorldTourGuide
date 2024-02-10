//
//  Location.swift
//  WorldTourGuide
//
//  Created by Jason on 2024/2/10.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable {
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    // since this is a read-only app, we should use computed id to justify the same data
    var id: String {
        name + cityName
    }
    // Equatable, lhs = left hand side, rhs = right hand side
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
