//
//  Untitled.swift
//  WeAct
//
//  Created by 주현아 on 7/11/25.
//

struct HabitPostDetailResponse: Codable {
    let userName: String
    let message: String
    let imageUrl: String
    let likeCount: Int
    let liked: Bool
    let comments: [HabitPostComment]
    let haemyeong: Bool
}

