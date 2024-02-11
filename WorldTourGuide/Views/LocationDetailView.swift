//
//  LocationDetailView.swift
//  WorldTourGuide
//
//  Created by Jason on 2024/2/10.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @Environment(LocationsViewModel.self) var vm
    let location: Location
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                
                VStack(alignment: .leading, spacing: 16.0) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topLeading) {
            backButton
        }
    }
}

extension LocationDetailView {
    private var imageSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : 400)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16.0, content: {
            Text(location.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let url = URL(string: location.link) {
                Link(destination: url, label: {
                    HStack(spacing: 4.0) {
                        Text("Read more on Wikipedia")
                            .font(.headline)
                        Image(systemName: "arrow.up.right")
                            .font(.subheadline)
                    }
                    .tint(.blue)
                })
            }
        })
    }
    
    private var mapLayer: some View {
        let mapCamera = MapCameraPosition.region(
            MKCoordinateRegion(center: location.coordinates,
                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        return Map(initialPosition: mapCamera) {
            Annotation(location.id, coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .shadow(radius: 10)
            }
        }
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var backButton: some View {
        Image(systemName: "xmark")
            .font(.headline)
            .padding(16)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            .padding()
            .onTapGesture {
                vm.sheetLocation = nil
            }
        
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
        .environment(LocationsViewModel())
}
