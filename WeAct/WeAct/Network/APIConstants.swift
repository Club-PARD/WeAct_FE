//
//  APIConstants.swift
//  WeAct
//
//  Created by 주현아 on 7/8/25.
//

// 공통 URL 및 엔드포인트 모음

import Foundation

struct APIConstants {
    static let baseURL = "https://naruto.asia"
    
    struct User {
        static let checkDuplicate = "/user/checkDuplicated" // + /{userId}
        static let create = "/user"
        static let login = "/auth/login"
    }
    
    struct Group {
        static let create = "/group"
        static let search = "/group/search"
    }
}
