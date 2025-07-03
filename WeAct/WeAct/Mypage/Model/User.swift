//
//  User.swift
//  WeAct
//
//  Created by 주현아 on 7/2/25.
//

struct User: Codable {
    var username: String
    var profileImageURL: String?
    
    static let sampleUser = User(username: "이주원", profileImageURL: "https://example.com/profile.jpg")
}
