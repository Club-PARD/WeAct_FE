//
//  SwiftDataUserModel.swift
//  WeAct
//
//  Created by 현승훈 on 7/9/25.
//


import SwiftData

@Model
class User {
    var userId: String      // 아이디
    var password: String    // 비밀번호 (서버 저장 주의)
    var userName: String    // 이름
    var gender: String?     // 성별
    
    init(userId: String, password: String, userName: String, gender: String?) {
        self.userId = userId
        self.password = password
        self.userName = userName
        self.gender = gender
    }
}
