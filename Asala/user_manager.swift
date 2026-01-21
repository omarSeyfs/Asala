import Foundation
import UIKit
import SwiftUI
import CryptoKit
import Security
class user_manager: ObservableObject {
    @Published var user_details: user_data?
    @Published var login_alert_message: String?
    struct user_data: Decodable {
        var emirates: [String]
        var exp: Int
        var premium: Bool
        var session_token: String
        let user_id: String
        var username: String
        var coins: Int
        enum CodingKeys: String, CodingKey {
            case emirates, exp, premium, session_token, user_id, username, coins
        }
    }
    struct user_data_response_template: Decodable {
        let display_message: String
        let operation_successful: Bool
        var user_data: user_data?
        enum CodingKeys: String, CodingKey {
            case display_message, operation_successful, user_data
        }
    }
    struct login_post_body: Encodable {
        let username: String
        let password: String
    }
    func log_in(username: String, password: String) async -> (user_data?, String, Bool) {
        if let login_url = URL(string:"https://asala-testing.onrender.com/login") {
            var request = URLRequest(url: login_url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let post_body = login_post_body(username: username, password: password)
            if let post_json = try? JSONEncoder().encode(post_body) {
                request.httpBody = post_json
                do {
                    let (data, _) = try await URLSession.shared.data(for:request)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let response = try decoder.decode(user_data_response_template.self, from: data)
                    return (response.user_data, response.display_message, response.operation_successful)
                    
                } catch {
                    print(error.localizedDescription, error)
                }
            }
        }
        return (nil, "Failed to contact server", false)
    }
    func create_user(username: String, password: String, emirates: [String], email: String) async -> (String, Bool) {
        struct post_body: Encodable {
            let username: String
            let password: String
            let emirates: [String]
            let email: String
        }
        if let signin_url = URL(string:"https://asala-testing.onrender.com/createuser") {
            var request = URLRequest(url: signin_url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let post_body = post_body(username:username,password:password,emirates:emirates, email: email)
            if let post_json = try? JSONEncoder().encode(post_body) {
                request.httpBody = post_json
                do {
                    let (data,_) = try await URLSession.shared.data(for: request)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let response = try decoder.decode(user_data_response_template.self, from: data)
                    return (response.display_message, response.operation_successful)
                } catch{
                    print(error.localizedDescription, error)
                }
            }
        }
        return ("Failed to contact server", false)
    }
    init(){}
}

