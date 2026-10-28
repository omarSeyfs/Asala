import SwiftUI

@MainActor
class AppState: ObservableObject {
    //@Published var apiManager = api_manager()
    @Published var userManager = user_manager()
    
}

struct ContentView: View {
    @State private var loggedIn = false
    @State private var showLogin = true
    @State private var needsEmirateSelection = false
    @StateObject private var appState = AppState()
    let timer = Timer.publish(every:1800, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
            if loggedIn {
                if needsEmirateSelection {
                    EmirateSelectionView(
                        onComplete: {
                            needsEmirateSelection = false
                        }
                    )
                    .environmentObject(appState)
                } else {
                    MainAppView()
                        .environmentObject(appState)
                }
            } else {
                ZStack {
                    Color(red: 10/255, green: 20/255, blue: 60/255)
                        .ignoresSafeArea()

                    VStack {
                        if showLogin {
                            LoginView(showLogin: $showLogin, loggedIn: $loggedIn, needsEmirateSelection: $needsEmirateSelection)
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
        }.onReceive(timer) { input in
            Task{if appState.userManager.password != nil {
                let (user_data, _, _) = await appState.userManager.log_in(username:appState.userManager.user_details!.username,password:appState.userManager.password!)
                appState.userManager.user_details = user_data
            }}}
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            Task{
                // Place holder for now cuz of the error, supposed to be replaced by the formula
                await appState.userManager.update_user_resources()
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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @Binding var needsEmirateSelection: Bool

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

            Button(){
                Task{
                    let (user_data,_,logged_in) = await appState.userManager.log_in(username:email, password:password)
                    appState.userManager.user_details = user_data
                    if logged_in {
                        appState.userManager.password = password
                    }
                    if logged_in {
                        appState.userManager.password = password
                        appState.userManager.user_details = user_data
                        
                        // data loaded here
                        await appState.userManager.get_locations()
                        await appState.userManager.get_events()
                        await appState.userManager.get_all_cosmetics()
                        
                        loggedIn = true
                        
                        let stored = UserDefaults.standard.stringArray(forKey: "selected_emirates")
                        if stored == nil || stored!.isEmpty {
                            needsEmirateSelection = true
                        }
                    }
                    
                }

            } label: {
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
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var confirmPassword = ""
    @State private var message = ""
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack(spacing: 16) {
            Text("SIGN UP")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            TextField("", text: $username, prompt: Text("Username").foregroundColor(.white.opacity(0.7)))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .textInputAutocapitalization(.never)
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

            Button() {
                Task {
                    let (display_message, _) = await appState.userManager.create_user(username:username,password:password,emirates:[], email:email)
                    print(display_message)
                    showLogin = true
                }
            }label: {
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
