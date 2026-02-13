import Foundation
import UIKit
import SwiftUI
import CryptoKit
import Security
public struct cosmetic_item: Decodable, Equatable, Identifiable, Hashable {
    public var id: UUID = UUID()
    var cosmetic_id: String
    var image_data: String
    var inapp_name: String
    var inapp_cost: Int
    enum CodingKeys: String, CodingKey {
        case cosmetic_id, image_data, inapp_name, inapp_cost
    }
}
public struct map_location: Decodable, Equatable, Identifiable, Hashable {
    public var id: UUID = UUID()
    var loc_id: String
    var loc_name: String
    var description: String
    var emirate: String
    var images: [String]
    var center_lat: Double
    var center_lon: Double
    enum CodingKeys: String, CodingKey {
        case loc_id, loc_name, description, emirate, images, center_lat, center_lon
    }
}
public struct event: Identifiable, Decodable, Equatable, Hashable {
    public var id: UUID = UUID()
    let event_id: String
    let emirate: String
    let event_name: String
    let exp_gained: Int
    let description: String
    let time_window: String
    let date_window: String
    let event_lat: Double
    let event_lon: Double
    let event_images: [String]
    let event_urls: [String]
    enum CodingKeys: String, CodingKey {
        case event_id, emirate, event_name, exp_gained, description, time_window, date_window, event_lat, event_lon, event_images, event_urls
    }
}
class user_manager: ObservableObject {
    @Published public var user_details: user_data?
    @Published var login_alert_message: String?
    @Published var password: String?
    @Published var cosmetics: [cosmetic_item] = []
    @Published var locations: [map_location] = []
    @Published var events: [event] = []
    @Published var equipped_head: cosmetic_item?
    @Published var equipped_body: cosmetic_item?
    @Published var equipped_face: cosmetic_item?
    var coin_difference: Int = 0
    var exp_difference: Int = 0
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
    struct loc_validation_response_template: Decodable {
        let valid_location: Bool
        let display_message: String
        let coins_gained: Int
        let exp_gained: Int
        enum CodingKeys: String, CodingKey {
            case valid_location, display_message, coins_gained, exp_gained
        }
    }
    public struct leaderboard_item: Decodable {
        let display_message: String
        let exp: Int
        let username: String
        enum CodingKeys: String, CodingKey {
            case display_message, exp, username
        }
    }
    enum resource {
        case coins, exp
    }
    func display_resource(resource_type: resource) -> Int {
        if user_details != nil {
        switch resource_type {
        case .coins:
            return self.user_details!.coins + self.coin_difference
        case .exp:
            return self.user_details!.exp + self.exp_difference
        }
        } else {
            return 0
        }
    }
    func validate_resource_change(increment: Int, resource_type: resource) -> Bool {
        if self.user_details != nil {
            switch resource_type {
            case .coins:
                if self.user_details!.coins + self.coin_difference + increment > 0 {
                    self.coin_difference += increment
                    return true
                } else {return false}
            case .exp:
                if self.user_details!.exp + self.exp_difference + increment > 0 {
                    self.exp_difference += increment
                    return true
                } else {return false}
            }
        } else {
            return false
        }
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
    func update_user_resources() async -> Void {
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
        let post_struct = post_body(session_data: session_data,exp_increment: self.exp_difference,coins_increment: self.coin_difference)
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let _ = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
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
    func validate_location(loc_id: String, user_lat: Float, user_lon: Float) async -> loc_validation_response_template? {
        if self.user_details == nil {
            return nil
        }
        struct post_body: Encodable {
            let session_data: session_details
            let loc_id: String
            let user_lat: Float
            let user_lon: Float
        }
        let backend_url = "https://asala-testing.onrender.com/validatelocation"
        let session_data = session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token)
        let post_struct = post_body(session_data:session_data,loc_id:loc_id,user_lat:user_lat,user_lon:user_lon)
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let response_data = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
            if let response_data = response_data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do{
                    let response = try decoder.decode(loc_validation_response_template.self, from: response_data)
                    return response
                }catch{
                    print(error.localizedDescription, error)
                    return nil
                }
            }
        }
        
        return nil
    }
    func get_leaderboard() async -> [leaderboard_item] {
        if self.user_details == nil {
            return []
        }
        struct post_body: Encodable {
            let session_data: session_details
        }
        let post_struct = post_body(session_data:session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = "https://asala-testing.onrender.com/getleaderboard"
            let data = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do {
                    let response = try decoder.decode([leaderboard_item].self,from: data)
                    return response
                } catch {
                    return []
                }
            }
        }
        return []
    }
    func update_user_emirates(emirates_arr:[String]) async -> Bool {
        if self.user_details == nil {
            return false
        }
        struct response: Decodable {
            let operation_successful: Bool
            let display_message: String
            enum CodingKeys: String, CodingKey {
                case operation_successful, display_message
            }
        }
        struct post_body: Encodable {
            let emirates: [String]
            let session_data: session_details
        }
        let post_struct = post_body(emirates:emirates_arr,session_data:session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = "https://asala-testing.onrender.com/setnewemirates"
            let data = await get_data_from_post_request(url_string:backend_url, json_data: post_json)
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let backend_response = try decoder.decode(response.self, from: data)
                    print(backend_response.display_message)
                    return backend_response.operation_successful
                } catch {
                    print("Server error")
                    return false
                }
            }
            
        }
        return false
    }
    func get_all_cosmetics() async -> Void {
        if self.user_details == nil {
            return
        }
        struct post_body: Encodable {
            let session_data: session_details
        }
        let post_struct = post_body(session_data:session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = "https://asala-testing.onrender.com/getcosmetics"
            let data = await get_data_from_post_request(url_string:backend_url, json_data: post_json)
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do {
                    self.cosmetics = try decoder.decode([cosmetic_item].self,from:data)
                } catch{
                    print(error.localizedDescription)
                    }
            }
        }
        
    }
    func get_locations() async -> Void {
        if self.user_details == nil {
            return
        }
        struct post_body: Encodable {
            let session_data: session_details
        }
        let post_struct = post_body(session_data:session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = "https://asala-testing.onrender.com/getlocations"
            let data = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do {
                    self.locations = try decoder.decode([map_location].self,from:data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    func get_events() async -> Void {
        if self.user_details == nil {
            return
        }
        struct post_body: Encodable {
            let session_data: session_details
        }
        let post_struct = post_body(session_data:session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = "https://asala-testing.onrender.com/getequippedcosmetics"
            let data = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do {
                    self.events = try decoder.decode([event].self,from:data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    func get_equipped_cosmetics() async -> Void {
        if (self.user_details == nil) || (self.cosmetics == []) {
            return
        }
        struct post_body: Encodable {
            let session_data: session_details
        }
        struct response: Decodable, Hashable, Identifiable {
            var id: UUID = UUID()
            let head_id: String
            let face_id: String
            let body_id: String
            enum CodingKeys: String, CodingKey {
                case head_id, face_id, body_id
            }
        }
        let post_struct = post_body(session_data:session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = "https://asaala-testing.onrender.com/getevents"
            let data = await get_data_from_post_request(url_string: backend_url, json_data: post_json)
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do {
                    let response_struct = try decoder.decode(response.self,from:data)
                    for cosmetic in self.cosmetics {
                        if cosmetic.cosmetic_id == response_struct.head_id {
                            self.equipped_head = cosmetic
                        } else if cosmetic.cosmetic_id == response_struct.body_id {
                            self.equipped_body = cosmetic
                        } else if cosmetic.cosmetic_id == response_struct.face_id {
                            self.equipped_face = cosmetic
                        }
                        if (self.equipped_head != nil) && (self.equipped_body != nil) && (self.equipped_face != nil) {
                            break
                        }
                        
                    }
                } catch {
                    print(error.localizedDescription, error)
                }
            }
        }
    }
    func assign_cosmetic_ownership(cosmetic_id: String) async -> Void {
        if self.user_details == nil {
            return
        }
        struct post_body: Encodable {
            let cosmetic_id: String
            let session_data: session_details
        }
        let post_struct = post_body(cosmetic_id: cosmetic_id, session_data: session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = "https://asala-testing.onrender.com/assigncosmeticownership"
            let _ = await get_data_from_post_request(url_string:backend_url,json_data:post_json)
        }
        
        
    }
    func toggle_cosmetic_equip(cosmetic_slot: String, cosmetic_id: String, equip: Bool) async -> Void {
        //cosmetic_slot is one of 'head', 'face', or 'body'
        //equip should be set to 'true' if the cosmetic is being equipped, and 'false' if the cosmetic is being unequipped
        if self.user_details == nil {
            return
        }
        struct post_body: Encodable {
            let cosmetic_id: String
            let cosmetic_slot: String
            let session_data: session_details
        }
        let post_struct = post_body(cosmetic_id: cosmetic_id, cosmetic_slot: cosmetic_slot, session_data: session_details(user_id:self.user_details!.user_id,session_token:self.user_details!.session_token))
        if let post_json = try? JSONEncoder().encode(post_struct) {
            let backend_url = equip ? "https://asala-testing.onrender.com/equipcosmetic" : "https://asala-testing.onrender.com/unequipcosmetic"
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
public struct session_details: Encodable {
    let user_id: String
    var session_token: String
}
extension cosmetic_item {
    func get_image() -> Image {
        if self.image_data != "" {
            let data: Data = Data(base64Encoded: self.image_data)!
            return Image(uiImage: UIImage(data: data)!)
        } else {
            return Image(systemName: "xmark.circle")
        }
    }
}
extension map_location {
    func get_image_arr() -> [Image] {
        if self.images != [] {
            var return_arr: [Image] = []
            for str in self.images {
                let data: Data = Data(base64Encoded: str)!
                let image = Image(uiImage: UIImage(data: data)!)
                return_arr.append(image)
            return return_arr
            }
                        
        }
        return [Image(systemName:"xmark.circle")]
    }
    func get_coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.center_lat, longitude: self.center_lon)
    }
}
extension event {
    func get_image_arr() -> [Image] {
        if self.event_images != [] {
            var return_arr: [Image] = []
            for str in self.event_images {
                let data: Data = Data(base64Encoded: str)!
                let image = Image(uiImage: UIImage(data: data)!)
                return_arr.append(image)
            return return_arr
            }
                        
        }
        return [Image(systemName:"xmark.circle")]
    }
    func get_coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.event_lat, longitude: self.event_lon)
    }
}
