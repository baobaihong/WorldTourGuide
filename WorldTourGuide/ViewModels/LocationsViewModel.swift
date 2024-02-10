//
//  LocationsViewModel.swift
//  WorldTourGuide
//
//  Created by Jason on 2024/2/10.
//

import Foundation
import MapKit
import SwiftUI

@Observable class LocationsViewModel {
    var locations: [Location]
    var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    // current region on map
    var mapCamera: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion())
    @ObservationIgnored let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // show list of locations
    var showLocationsList: Bool = false
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: mapLocation)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapCamera = MapCameraPosition.region(MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan))
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList = !showLocationsList
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed() {
        // get the current index
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else { return }
        
        // check if it's the last one in locations
        // if it's the last one, loop back to the first one
        guard locations.indices.contains(currentIndex + 1) else {
            showNextLocation(location: locations.first!)
            return
        }
        let nextLocation = locations[currentIndex + 1]
        showNextLocation(location: nextLocation)
    }
}
