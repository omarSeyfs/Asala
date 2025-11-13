//
//  ExploreView.swift
//  Asala
//
//  Created by Omar Seyfetdinov on 05/09/2025.
//

import SwiftUI
import MapKit

// MARK: - Explore Screen
struct ExploreScreen: View {
    @State private var locations: [LocCard] = [
        .init(id: "qasr", city: "Abu Dhabi", title: "Qasr Al Hosn", time: "11AM - 7PM", imageName: "qasr_sample"),
        .init(id: "jebel", city: "AL AIN", title: "Jebel Al H...", time: "11AM - 7PM", imageName: "mountain_sample"),
    ]
    @State private var events: [EventItem] = [
        .init(id: "book", title: "Abu Dhabi book fair", period: "11 - 18 JAN", time: "9AM - 9PM", xp: 3, imageName: "bookfair_sample"),
        .init(id: "plants", title: "Native: Plants in the UAE", period: "21 - 30 MAY", time: "6PM - 12AM", xp: 5, imageName: "plants_sample"),
        .init(id: "expo", title: "Najah Expo 2025", period: "11 - 18 DEC", time: "—", xp: 2, imageName: "expo_sample")
    ]

    @State private var showLocationFocus: LocCard?
    @State private var showEventFocus: EventItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                // EXPLORE >
                HStack {
                    Text("EXPLORE >")
                        .font(Theme.pixel(28))
                        .foregroundColor(Theme.accent)
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)

                // Horizontal cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(locations) { loc in
                            LocationCardView(loc: loc) {
                                showLocationFocus = loc
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }
                .padding(.bottom, 8)

                // EVENTS >
                HStack {
                    Text("EVENTS >")
                        .font(Theme.pixel(28))
                        .foregroundColor(Theme.accent)
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)

                VStack(spacing: 12) {
                    ForEach(events) { event in
                        EventRowView(event: event) {
                            showEventFocus = event
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
            }
        }
        .background(Theme.bg)
        .sheet(item: $showLocationFocus) { loc in
            LocationFocusView(loc: loc)
        }
        .sheet(item: $showEventFocus) { event in
            EventFocusView(event: event)
        }
    }
}

// MARK: - Location Card (carousel)
struct LocationCardView: View {
    let loc: LocCard
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image
            ZStack(alignment: .bottomTrailing) {
                Image(loc.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 170)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(Theme.cardStroke(corner: 16))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(loc.city)
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))

                Text(loc.title)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)

                Text(loc.time)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))
            }

            HStack(spacing: 10) {
                HeartChip()
                XpChip(value: 5)

                Spacer(minLength: 6)

                DiscoverButton {
                    onTap()
                }
            }
            .padding(.top, 4)
        }
        .padding(12)
        .frame(width: 300)
        .background(Theme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(Theme.cardStroke())
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 6)
    }
}

// MARK: - Event Row
struct EventRowView: View {
    let event: EventItem
    var onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Thumb
            Image(event.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 66, height: 66)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(Theme.cardStroke(corner: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(event.period)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))

                Text(event.title)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)

                Text(event.time)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            XpChip(value: event.xp)
                .frame(width: 44)

            Button {
                onTap()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.text)
                    .padding(8)
                    .background(Theme.panel.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.border, lineWidth: 1))
            }
        }
        .padding(12)
        .background(Theme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(Theme.cardStroke(corner: 16))
        .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 5)
        .onTapGesture { onTap() }
    }
}

// MARK: - Focus Sheets
struct LocationFocusView: View {
    @Environment(\.dismiss) private var dismiss
    let loc: LocCard
    @State private var mapPos = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.485, longitude: 54.356),
                           span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    )

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    Image(loc.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(Theme.cardStroke(corner: 16))
                        .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)
                        .padding(.top, 12)

                    HStack {
                        Text(loc.city)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        HeartChip()
                        XpChip(value: 5)
                    }

                    Text(loc.title)
                        .font(Theme.pixel(26))
                        .foregroundColor(.white)

                    Text("""
In a city like Abu Dhabi, where things are constantly evolving, there are some parts where time almost stands still. Qasr Al Hosn is one of them. The city's oldest stone building is a commanding figure surrounded by the emirate's skyline - a beautiful contrast between old and new.
""")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(.white.opacity(0.85))
                        .lineSpacing(2)

                    // Links + Timings blocks
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            Text("Links")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.85))
                            Spacer()
                            Text("https://qasralhosn.ae")
                                .font(.system(size: 12, weight: .regular, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Divider().background(Theme.border)

                        HStack(spacing: 10) {
                            Text("Timings")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.85))
                            Spacer()
                            Text(loc.time)
                                .font(.system(size: 12, weight: .regular, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding()
                    .background(Theme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(Theme.cardStroke(corner: 14))

                    // mini map box
                    Map(position: $mapPos)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(Theme.cardStroke(corner: 14))
                }
                .padding(18)
            }

            // Close chip
            Button {
                dismiss()
            } label: {
                Text("X")
                    .font(Theme.pixel(20))
                    .foregroundColor(.black)
                    .frame(width: 56, height: 56)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
                    .padding(16)
            }
        }
    }
}

struct EventFocusView: View {
    @Environment(\.dismiss) private var dismiss
    let event: EventItem

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Image(event.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(Theme.cardStroke(corner: 16))
                        .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)
                        .padding(.top, 12)

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Abu Dhabi")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))
                            Text(event.title)
                                .font(Theme.pixel(24))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        HeartChip()
                        XpChip(value: 5)
                    }

                    Text("""
The ‘Native’ exhibition explores the life conditions of each plant indigenous to the UAE’s landscape, examining the surrounding atmosphere that influences its growth and gives it unique variations in color, texture, size, and behavior. This exhibition will be held until December 2025.
""")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(.white.opacity(0.85))

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Links")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.85))
                        Text("https://abudhabiculture.ae/events/native-plants-in-the-uae")
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                        Divider().background(Theme.border)
                        Text("Timings: ALL WEEK: 9:00 AM - 8:00 PM")
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(Theme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(Theme.cardStroke(corner: 14))
                }
                .padding(18)
            }

            Button {
                dismiss()
            } label: {
                Text("X")
                    .font(Theme.pixel(20))
                    .foregroundColor(.black)
                    .frame(width: 56, height: 56)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
                    .padding(16)
            }
        }
    }
}

// MARK: - Small UI bits
struct HeartChip: View {
    @State private var liked = false
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) { liked.toggle() }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: liked ? "heart.fill" : "heart")
                    .font(.system(size: 14, weight: .bold))
                Text("")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
            }
            .foregroundColor(Theme.text)
            .frame(height: 34)
            .frame(width: 42)
            .background(Theme.panel.opacity(0.9))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .tint(Theme.heartPink)
    }
}

struct XpChip: View {
    let value: Int
    var body: some View {
        HStack(spacing: 6) {
            Text("\(value)")
                .font(.system(size: 13, weight: .heavy, design: .monospaced))
            Text("XP")
                .font(.system(size: 13, weight: .heavy, design: .monospaced))
        }
        .foregroundColor(.black)
        .padding(.horizontal, 10)
        .frame(height: 34)
        .background(Theme.xpGreen)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
    }
}

struct DiscoverButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("DISCOVER")
                    .font(.system(size: 13, weight: .heavy, design: .monospaced))
                Text(">")
                    .font(.system(size: 13, weight: .heavy, design: .monospaced))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .background(Theme.accent)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
        }
    }
}

// MARK: - Simple data models for this screen (local)
struct LocCard: Identifiable, Equatable {
    let id: String
    let city: String
    let title: String
    let time: String
    let imageName: String
}
struct EventItem: Identifiable, Equatable {
    let id: String
    let title: String
    let period: String
    let time: String
    let xp: Int
    let imageName: String
}
