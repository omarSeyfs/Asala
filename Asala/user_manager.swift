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
            let url_string = "https://asala-testing.onrender.com/login"
            let post_body = login_post_body(username: username, password: password)
            if let post_json = try? JSONEncoder().encode(post_body) {
                let data = await get_data_from_post_request(url_string:url_string,json_data:post_json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do{
                    let response = try decoder.decode(user_data_response_template.self, from: data!)
                    return (response.user_data, response.display_message, response.operation_successful)
                } catch{
                    print(error.localizedDescription)
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
        let url_string = "https://asala-testing.onrender.com/createuser"
        let post_struct = post_body(username:username,password:password,emirates:emirates, email: email)
        if let post_json = try? JSONEncoder().encode(post_struct) {
            do {
                let data = (await get_data_from_post_request(url_string: url_string, json_data: post_json))!
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let response = try decoder.decode(user_data_response_template.self, from: data)
                return (response.display_message, response.operation_successful)
            } catch{
                print(error.localizedDescription, error)
                }
            }
        
        return ("Failed to contact server", false)
    }
    func update_user_resources(coins_increment: Int, exp_increment: Int) async -> Void {
        if self.user_details == nil {
            return
        }
        struct post_body: Encodable {
            let session_data: session_details
            let exp_increment: Int
            let coins_increment: Int
        }
        let backend_url = "https://asala-testing.onrender.com/updateuserresources"
        let session_data = session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token)
        let post_struct = post_body(session_data: session_data,exp_increment: exp_increment,coins_increment: coins_increment)
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let _ = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
            self.user_details!.coins += coins_increment
            self.user_details!.exp += exp_increment
        }
            
        
    }
    func delete_account(user_password: String) async -> Void {
        if self.user_details == nil {
            return
        }
        struct post_body: Encodable {
            let session_data: session_details
            let user_password: String
        }
        let backend_url = "https://asala-testing.onrender.com/updateuserresources"
        let session_data = session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token)
        let post_struct = post_body(session_data:session_data,user_password:user_password)
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let _ = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
        }
    }
    init(){}
}
public func get_data_from_post_request(url_string: String, json_data: Data) async -> Data? {
    if let request_url = URL(string:url_string) {
        var request = URLRequest(url:request_url)
        request.httpMethod = "POST"
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.httpBody = json_data
        do {
            let (data,_) = try await URLSession.shared.data(for: request)
            return data
            
        } catch {
            print(error.localizedDescription, error)
        }
    }
    return nil
}


