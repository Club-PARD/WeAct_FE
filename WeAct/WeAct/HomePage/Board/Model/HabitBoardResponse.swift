//
//  HabitPostResponse.swift
//  WeAct
//
//  Created by 주현아 on 7/11/25.
//

import Foundation

struct HabitBoardResponse: Identifiable, Codable, Hashable {
    var id: Int { postId }
    let userName: String
    let imageUrl: String
    let likeCount: Int
    let postId: Int
    let haemyeong: Bool
}
