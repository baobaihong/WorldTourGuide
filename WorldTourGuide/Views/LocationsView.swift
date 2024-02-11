//
//  LocationView.swift
//  WorldTourGuide
//
//  Created by Jason on 2024/2/10.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    @Environment(LocationsViewModel.self) private var vm
    let maxWidthForIpad: CGFloat = 700
    
    
    var body: some View {
        @Bindable var bindingvm = vm
        ZStack {
            mapLayer
            VStack {
                header
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                Spacer()
                locationsPreviewStack
            }
        }
        .sheet(item: $bindingvm.sheetLocation) { location in
            LocationDetailView(location: location)
        }
    }
}

extension LocationsView {
    private var header: some View {
        VStack {
            Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                .font(.title2)
                .fontWeight(.black)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .animation(.none, value: vm.mapLocation)
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.down")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .padding()
                        .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                }
                .onTapGesture {
                    vm.toggleLocationsList()
                }
            if vm.showLocationsList {
                LocationsListView()
            }
        }
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        // if view model is referred in @Environment, use @Bindable inside view's body to make it binding
        @Bindable var bindingvm = vm
        return Map(position: $bindingvm.mapCamera) {
            ForEach(vm.locations) { location in
                Annotation(location.id, coordinate: location.coordinates) {
                    LocationMapAnnotationView()
                        .zIndex(vm.mapLocation == location ? 0 : 1)
                        .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                        .shadow(radius: 10)
                        .onTapGesture {
                            vm.showNextLocation(location: location)
                        }
                    
                }
            }
        }
    }
    
    private var locationsPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: .black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}

#Preview {
    LocationsView()
        .environment(LocationsViewModel())
}
