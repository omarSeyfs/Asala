import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    NavigationLink("Edit Profile") { Text("Edit Profile Screen") }
                    NavigationLink("Change Password") { Text("Change Password Screen") }
                }

                Section(header: Text("App")) {
                    Toggle("Dark Mode", isOn: .constant(true))
                    NavigationLink("Notifications") { Text("Notification Settings") }
                }

                Section(header: Text("Support")) {
                    NavigationLink("Help Center") { Text("Help Screen") }
                    NavigationLink("Contact Us") { Text("Contact Screen") }
                }

                Section {
                    Button(role: .destructive) {
                        print("Log out tapped")
                    } label: {
                        Text("Log Out")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
