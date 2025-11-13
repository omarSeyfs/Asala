import SwiftUI

@MainActor
class AppState: ObservableObject {
    @Published var apiManager = api_manager()
    @Published var userManager = user_manager()
}

struct ContentView: View {
    @State private var loggedIn = false
    @State private var showLogin = true
    @StateObject private var appState = AppState()

    var body: some View {
        if loggedIn {
            MainAppView()
                .environmentObject(appState)
        } else {
            ZStack {
                Color(red: 10/255, green: 20/255, blue: 60/255)
                    .ignoresSafeArea()

                VStack {
                    if showLogin {
                        LoginView(showLogin: $showLogin, loggedIn: $loggedIn)
                            .environmentObject(appState)
                    } else {
                        SignUpView(showLogin: $showLogin, loggedIn: $loggedIn)
                            .environmentObject(appState)
                    }
                }
                .padding()
                .background(Color(red: 20/255, green: 30/255, blue: 80/255).opacity(0.95))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 4)
                .padding()
            }
        }
    }
}

struct LoginView: View {
    @Binding var showLogin: Bool
    @Binding var loggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("LOGIN")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            TextField("", text: $email, prompt: Text("Email").foregroundColor(.white.opacity(0.7)))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .textInputAutocapitalization(.never)

            SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white.opacity(0.7)))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)

            Button(action: { loggedIn = true }) {
                Text("LOGIN")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
            }

            Button("SIGN UP") { showLogin = false }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
        }
    }
}

struct SignUpView: View {
    @Binding var showLogin: Bool
    @Binding var loggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var message = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("SIGN UP")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            TextField("", text: $email, prompt: Text("Email").foregroundColor(.white.opacity(0.7)))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .textInputAutocapitalization(.never)

            SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white.opacity(0.7)))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)

            SecureField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.white.opacity(0.7)))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)

            Button(action: { loggedIn = true }) {
                Text("SIGN UP")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
            }

            Button(action: { showLogin = true }) {
                Text("GO TO LOGIN")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
