//
//  MapsScreen.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 25/09/2025.
//

import SwiftUI
import MapKit

struct MapPlace: Identifiable {
    let id: String
    let title: String
    let city: String
    let time: String
    let coordinate: CLLocationCoordinate2D
    let imageName: String
}

struct MapsScreen: View {
    @State var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedPlace: MapPlace?

    // Hardcoded sample pins
    private let samplePlaces: [MapPlace] = [
        MapPlace(
            id: "qasr",
            title: "Qasr Al Hosn",
            city: "Abu Dhabi",
            time: "11AM - 7PM",
            coordinate: CLLocationCoordinate2D(latitude: 24.485, longitude: 54.356),
            imageName: "qasr_sample"
        ),
        MapPlace(
            id: "jebel",
            title: "Jebel Hafeet",
            city: "Al Ain",
            time: "9AM - 6PM",
            coordinate: CLLocationCoordinate2D(latitude: 24.058, longitude: 55.777),
            imageName: "mountain_sample"
        ),
        MapPlace(
            id: "louvre",
            title: "Louvre Abu Dhabi",
            city: "Abu Dhabi",
            time: "10AM - 8PM",
            coordinate: CLLocationCoordinate2D(latitude: 24.533, longitude: 54.396),
            imageName: "bookfair_sample"
        )
    ]

    var body: some View {
        ZStack {
            Map(position: $cameraPosition, interactionModes: .all) {
                ForEach(samplePlaces) { place in
                    Annotation(place.title, coordinate: place.coordinate) {
                        Button {
                            selectedPlace = place
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                    .shadow(radius: 2)
                                Text(place.title)
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }
                }
            }

            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .mapStyle(.standard)
            VStack{
                Spacer()
                search_view(locs_arr: samplePlaces, cameraPosition: $cameraPosition)
            }
        }
        // Focus view sheet
        .sheet(item: $selectedPlace) { place in
            LocationFocusView(
                loc: LocCard(
                    id: place.id,
                    city: place.city,
                    title: place.title,
                    time: place.time,
                    imageName: place.imageName
                )
            )
        }
        .onAppear {
            // Center the map on first place
            if let first = samplePlaces.first {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: first.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
                    )
                )
            }
        }
    }
}
#Preview {
    MapsScreen()
}

struct search_view: View{
    @State var locs_arr: [MapPlace]
    @State var search_string: String = ""
    @Binding var cameraPosition: MapCameraPosition
    var body: some View {
        HStack{
            TextField("Search for a location...", text: $search_string)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .onChange(of: search_string) {
                    for loc in locs_arr {
                        if loc.title.lowercased() == search_string.lowercased() {
                            cameraPosition = .region(
                                MKCoordinateRegion(
                                    center: loc.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                )
                            )
                            search_string = ""
                            break
                        }
                    }
                }
            Spacer()
            Spacer()
                .frame(width:60,height:60)
            }
        .padding()
        
        }
    }
