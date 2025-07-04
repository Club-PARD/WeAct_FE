//
//  User.swift
//  WeAct
//
//  Created by 주현아 on 7/2/25.
//
import UIKit

struct UserModel: Codable {
    var username: String
    var profileImageURL: String?
    
    // ❌ Codable 제외 (직렬화 X)
    var localProfileImage: UIImage? = UIImage(named: "profile")
    
    // 필요한 경우에만 CodingKeys 선언
    private enum CodingKeys: String, CodingKey {
        case username
        case profileImageURL
        // localProfileImage는 제외함
    }

    static let sampleUser = UserModel(
        username: "이주원",
        profileImageURL: nil,
        localProfileImage: UIImage(named: "profile")
    )
}
