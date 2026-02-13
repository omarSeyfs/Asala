//
//  SettingsScreen.swift
//  Asala
//

import SwiftUI
import StoreKit

struct SettingsScreen: View {
    @EnvironmentObject var appState: AppState
    
    @State private var showLogoutConfirm = false
    @State private var showDeleteAccountConfirm = false
    @State private var showClearCacheConfirm = false
    @State private var showEditProfile = false
    @State private var showHelp = false
    @State private var showAbout = false
    @State private var showPrivacy = false
    @State private var showTerms = false
    
    // user settings
    @AppStorage("user_age") private var userAge: Int = 18
    @AppStorage("user_gender") private var userGender: String = "Male"
    @AppStorage("user_country") private var userCountry: String = "United Arab Emirates"
    @AppStorage("user_bio") private var userBio: String = ""
    
    // app preferences
    @AppStorage("notifications_enabled") private var notificationsEnabled = true
    @AppStorage("sound_effects_enabled") private var soundEffectsEnabled = true
    @AppStorage("music_enabled") private var musicEnabled = true
    @AppStorage("haptics_enabled") private var hapticsEnabled = true
    @AppStorage("language") private var selectedLanguage = "English"
    @AppStorage("theme_mode") private var selectedTheme = "Auto"
    
    let languages = ["English", "Arabic"]
    let themes = ["Auto", "Light", "Dark"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // header section
                HStack {
                    Text("SETTINGS >")
                        .font(Theme.pixel(28))
                        .foregroundColor(Theme.accent)
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
                
                // account info section
                if let user = appState.userManager.user_details {
                    VStack(alignment: .leading, spacing: 14) {
                        
                        SectionTitle(title: "ACCOUNT")
                        
                        InfoCard(label: "USERNAME", value: user.username)
                        InfoCard(label: "COINS", value: "\(user.coins) 🪙")
                        InfoCard(label: "XP", value: "\(user.exp)")
                        InfoCard(label: "LEVEL", value: "LVL \(calculateLevel(xp: user.exp))")
                        
                        SimpleButton(title: "EDIT PROFILE", icon: "pencil.circle.fill") {
                            showEditProfile = true
                        }
                    }
                    .padding(.horizontal, 18)
                }
                
                // profile details
                if appState.userManager.user_details != nil {
                    VStack(alignment: .leading, spacing: 14) {
                        
                        SectionTitle(title: "PROFILE")
                        
                        InfoCard(label: "AGE", value: "\(userAge)")
                        InfoCard(label: "GENDER", value: userGender)
                        InfoCard(label: "COUNTRY", value: userCountry)
                    }
                    .padding(.horizontal, 18)
                }
                
                // app preferences
                VStack(alignment: .leading, spacing: 14) {
                    
                    SectionTitle(title: "PREFERENCES")
                    
                    // notifications toggle
                    Toggle(isOn: $notificationsEnabled) {
                        Label("NOTIFICATIONS", systemImage: "bell.fill")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .tint(Theme.accent)
                    .padding(12)
                    .background(Theme.panel)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border))
                    
                    Toggle(isOn: $soundEffectsEnabled) {
                        Label("SOUND EFFECTS", systemImage: "speaker.wave.2.fill")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .tint(Theme.accent)
                    .padding(12)
                    .background(Theme.panel)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border))
                    
                    Toggle(isOn: $musicEnabled) {
                        Label("MUSIC", systemImage: "music.note")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .tint(Theme.accent)
                    .padding(12)
                    .background(Theme.panel)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border))
                    
                    Toggle(isOn: $hapticsEnabled) {
                        Label("HAPTIC FEEDBACK", systemImage: "waveform")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .tint(Theme.accent)
                    .padding(12)
                    .background(Theme.panel)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border))
                    
                    // language picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LANGUAGE")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Picker("", selection: $selectedLanguage) {
                            ForEach(languages, id: \.self) { lang in
                                Text(lang)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(12)
                    .background(Theme.panel)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border))
                    
                    // theme picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("THEME")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Picker("", selection: $selectedTheme) {
                            ForEach(themes, id: \.self) { theme in
                                Text(theme)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(12)
                    .background(Theme.panel)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border))
                }
                .padding(.horizontal, 18)
                
                // support section
                VStack(alignment: .leading, spacing: 14) {
                    
                    SectionTitle(title: "SUPPORT")
                    
                    SimpleButton(title: "HELP CENTER", icon: "questionmark.circle.fill") {
                        showHelp = true
                    }
                    
                    SimpleButton(title: "CONTACT US", icon: "envelope.fill") {
                        openEmail()
                    }
                    
                    SimpleButton(title: "RATE APP", icon: "star.fill") {
                        rateApp()
                    }
                    
                    SimpleButton(title: "PRIVACY POLICY", icon: "hand.raised.fill") {
                        showPrivacy = true
                    }
                    
                    SimpleButton(title: "TERMS OF SERVICE", icon: "doc.text.fill") {
                        showTerms = true
                    }
                    
                    SimpleButton(title: "ABOUT ASALA", icon: "info.circle.fill") {
                        showAbout = true
                    }
                }
                .padding(.horizontal, 18)
                
                // data management
                if appState.userManager.user_details != nil {
                    VStack(alignment: .leading, spacing: 14) {
                        
                        SectionTitle(title: "DATA & STORAGE")
                        
                        SimpleButton(title: "CLEAR CACHE", icon: "trash.fill", color: .orange) {
                            showClearCacheConfirm = true
                        }
                        
                        SimpleButton(title: "EXPORT MY DATA", icon: "square.and.arrow.up.fill") {
                            exportUserData()
                        }
                    }
                    .padding(.horizontal, 18)
                }
                
                // danger zone
                if appState.userManager.user_details != nil {
                    VStack(alignment: .leading, spacing: 14) {
                        
                        SectionTitle(title: "ACCOUNT ACTIONS")
                        
                        Button(action: {
                            showLogoutConfirm = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                
                                Text("LOG OUT")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red.opacity(0.3), Color.red.opacity(0.1)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))
                        }
                        
                        SimpleButton(title: "DELETE ACCOUNT", icon: "exclamationmark.triangle.fill", color: .red) {
                            showDeleteAccountConfirm = true
                        }
                    }
                    .padding(.horizontal, 18)
                }
                
                // footer
                VStack(spacing: 8) {
                    Text("VERSION 1.0.0")
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("MADE WITH ❤️ BY THE ASALA TEAM")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.3))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Theme.bg)
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(age: $userAge, gender: $userGender, country: $userCountry, bio: $userBio)
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showTerms) {
            TermsOfServiceView()
        }
        .alert("Log Out", isPresented: $showLogoutConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                appState.userManager.user_details = nil
                appState.userManager.password = nil
            }
        } message: {
            if let user = appState.userManager.user_details {
                Text("Are you sure you want to log out, \(user.username)?")
            } else {
                Text("Are you sure you want to log out?")
            }
        }
        .alert("Delete Account", isPresented: $showDeleteAccountConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                appState.userManager.user_details = nil
                appState.userManager.password = nil
            }
        } message: {
            if let user = appState.userManager.user_details {
                Text("This will permanently delete '\(user.username)' and all data (\(user.coins) coins, \(user.exp) XP). This cannot be undone.")
            } else {
                Text("This action cannot be undone.")
            }
        }
        .alert("Clear Cache", isPresented: $showClearCacheConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                clearCache()
            }
        } message: {
            Text("Clear temporary files and cached data? Your account data will not be affected.")
        }
    }
    
    // helper methods
    
    private func calculateLevel(xp: Int) -> Int {
        return max(1, xp / 100)
    }
    
    private func openEmail() {
        let email = "AsalaBusinessApp@gmail.com"
        let subject = "Asala App Support"
        let body = "Hi Asala Team,\n\n"
        
        let coded = "mailto:\(email)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL = coded.flatMap({ URL(string: $0) }) {
            UIApplication.shared.open(emailURL)
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func exportUserData() {
        guard let user = appState.userManager.user_details else { return }
        
        let userData = """
        === ASALA USER DATA EXPORT ===
        Username: \(user.username)
        Coins: \(user.coins)
        XP: \(user.exp)
        Level: \(calculateLevel(xp: user.exp))
        Age: \(userAge)
        Gender: \(userGender)
        Country: \(userCountry)
        Bio: \(userBio)
        Export Date: \(Date())
        =============================
        """
        
        let activityVC = UIActivityViewController(activityItems: [userData], applicationActivities: nil)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func clearCache() {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil)
            for file in files {
                try FileManager.default.removeItem(at: file)
            }
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
}

// MARK: - UI Components

struct SectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(Theme.accent)
    }
}

struct InfoCard: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.accent)
        }
        .padding(12)
        .background(Theme.panel)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
    }
}

struct SimpleButton: View {
    let title: String
    let icon: String
    var color: Color = Theme.accent
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(12)
            .background(Theme.panel)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
        }
    }
}

// MARK: - Edit Profile

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var age: Int
    @Binding var gender: String
    @Binding var country: String
    @Binding var bio: String
    
    @State private var tempAge: Int
    @State private var tempGender: String
    @State private var tempCountry: String
    @State private var tempBio: String
    
    let genderOptions = ["Male", "Female"]
    let countryOptions = ["United Arab Emirates", "Saudi Arabia", "Egypt", "United States", "United Kingdom", "Canada", "Australia", "India", "Pakistan", "Turkey", "Other"]
    
    init(age: Binding<Int>, gender: Binding<String>, country: Binding<String>, bio: Binding<String>) {
        self._age = age
        self._gender = gender
        self._country = country
        self._bio = bio
        self._tempAge = State(initialValue: age.wrappedValue)
        self._tempGender = State(initialValue: gender.wrappedValue)
        self._tempCountry = State(initialValue: country.wrappedValue)
        self._tempBio = State(initialValue: bio.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // age slider
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AGE")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                        
                        HStack {
                            Text("\(tempAge)")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .frame(width: 50)
                            
                            Slider(value: Binding(
                                get: { Double(tempAge) },
                                set: { tempAge = Int($0) }
                            ), in: 13...100, step: 1)
                            .tint(Theme.accent)
                        }
                        .padding()
                        .background(Theme.panel)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
                    }
                    
                    // gender
                    VStack(alignment: .leading, spacing: 8) {
                        Text("GENDER")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                        
                        Picker("Gender", selection: $tempGender) {
                            ForEach(genderOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        .background(Theme.panel)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
                    }
                    
                    // country dropdown
                    VStack(alignment: .leading, spacing: 8) {
                        Text("COUNTRY")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                        
                        Picker("Country", selection: $tempCountry) {
                            ForEach(countryOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Theme.accent)
                        .padding()
                        .background(Theme.panel)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
                    }
                    
                    // bio text area
                    VStack(alignment: .leading, spacing: 8) {
                        Text("BIO")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                        
                        ZStack(alignment: .topLeading) {
                            if tempBio.isEmpty {
                                Text("Tell us about yourself...")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.3))
                                    .padding(.top, 8)
                                    .padding(.leading, 12)
                            }
                            
                            TextEditor(text: $tempBio)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.white)
                                .frame(height: 120)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        }
                        .padding(8)
                        .background(Theme.panel)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
                    }
                }
                .padding()
            }
            .background(Theme.bg)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        age = tempAge
                        gender = tempGender
                        country = tempCountry
                        bio = tempBio
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                    .fontWeight(.bold)
                }
            }
        }
    }
}

// MARK: - Help

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HelpSection(title: "GETTING STARTED", content: "Learn the basics of using Asala and start your journey!")
                    HelpSection(title: "EARNING COINS", content: "Complete quests, win battles, and participate in events to earn coins.")
                    HelpSection(title: "LEVELING UP", content: "Gain XP by completing activities. Higher levels unlock more features!")
                }
                .padding()
            }
            .background(Theme.bg)
            .navigationTitle("Help Center")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Theme.accent)
                }
            }
        }
    }
}

struct HelpSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.accent)
            Text(content)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Theme.panel)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
    }
}

// MARK: - About

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Theme.accent)
                        .padding(.top, 40)
                    
                    Text("ASALA")
                        .font(Theme.pixel(32))
                        .foregroundColor(Theme.accent)
                    
                    Text("VERSION 1.0.0")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Asala is your ultimate gaming companion, helping you track progress, earn rewards, and connect with friends.")
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Divider().background(Theme.border)
                        
                        Text("DEVELOPED BY")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                        Text("The Asala Team")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Divider().background(Theme.border)
                        
                        Text("© 2026 Asala. All rights reserved.")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding()
                    .background(Theme.panel)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
                }
                .padding()
            }
            .background(Theme.bg)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Theme.accent)
                }
            }
        }
    }
}

// MARK: - Privacy Policy

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Last Updated: February 2026")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                    
                    PolicySection(title: "1. DATA COLLECTION", content: "We collect information you provide when creating an account, including username and gameplay data.")
                    PolicySection(title: "2. DATA USAGE", content: "Your data is used to provide and improve our services, personalize your experience, and communicate with you.")
                    PolicySection(title: "3. DATA SECURITY", content: "We implement security measures to protect your personal information from unauthorized access.")
                    PolicySection(title: "4. YOUR RIGHTS", content: "You have the right to access, modify, or delete your personal data at any time.")
                }
                .padding()
            }
            .background(Theme.bg)
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Theme.accent)
                }
            }
        }
    }
}

// MARK: - Terms of Service

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Last Updated: February 2026")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                    
                    PolicySection(title: "1. ACCEPTANCE", content: "By using Asala, you agree to these terms and conditions.")
                    PolicySection(title: "2. USER CONDUCT", content: "Users must not engage in cheating, harassment, or any behavior that violates our community guidelines.")
                    PolicySection(title: "3. ACCOUNT TERMINATION", content: "We reserve the right to suspend or terminate accounts that violate these terms.")
                    PolicySection(title: "4. CHANGES TO TERMS", content: "We may update these terms from time to time. Continued use constitutes acceptance of changes.")
                }
                .padding()
            }
            .background(Theme.bg)
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Theme.accent)
                }
            }
        }
    }
}

struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.accent)
            Text(content)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(AppState())
}
