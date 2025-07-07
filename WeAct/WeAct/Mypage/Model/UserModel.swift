//
//  User.swift
//  WeAct
//
//  Created by 주현아 on 7/2/25.
//
import UIKit
import SwiftUI

struct UserModel: Codable {
    var id: Int?
    var userId: String?
    var pw: String?
    var userName: String
    var gender: String?
    var profileImageURL: String?
    
    // ❌ Codable 제외 (직렬화 X)
    var localProfileImage: UIImage? = UIImage(named: "profile")
    
    // 필요한 경우에만 CodingKeys 선언
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case pw
        case userName
        case gender
        case profileImageURL
        // localProfileImage는 제외함
    }

    
}
