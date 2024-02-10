//
//  WorldTourGuideApp.swift
//  WorldTourGuide
//
//  Created by Jason on 2024/2/10.
//

import SwiftUI

@main
struct WorldTourGuideApp: App {
    @State private var vm = LocationsViewModel()

    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environment(vm)
        }
    }
}
