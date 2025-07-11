//
//  HabitRequest.swift
//  WeAct
//
//  Created by 주현아 on 7/11/25.
//

import Foundation

// 인증 요청 데이터 모델
struct HabitRequest: Codable {
    var roomId: Int
    var message: String
    var isHaemyeong: Bool
}
