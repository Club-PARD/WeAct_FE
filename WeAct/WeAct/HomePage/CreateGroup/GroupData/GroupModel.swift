//
//  GroupModel.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

//// Response(서버 응답)
//struct RoomModel: Decodable {
//    let roomId: Int // 방 식별자 아이디, 몇 번째 방
//    let roomName: String
//    let creatorName: String // 방 주최자 이름
//    let userInviteIds: [Int] // 초대장 아이디들
//}
//
//// Request(내가 보내는 바디)
//struct RoomRequest: Encodable {
//    let invitedIds: [Int] // 초대받은 user들 Id
//    let roomName: String
//    let startDate: String
//    let endDate: String
//    let reward: String
//    let dayCountByWeek: Int // 주 n회
//    let creatorId: Int // 방 주최자 user id
//}

struct GroupModel: Hashable, Identifiable, Codable {
    let id = UUID()
    let name: String
    let period: String
    let reward: String
    let partners: [String]
    let selectedDaysString: [String]
    let selectedDaysCount: Int
    var habitText: String
}

extension GroupModel {
    var frequencyText: String {
        return selectedDaysCount == 7 ? "매일" : "주 \(selectedDaysCount)회"
    }

    var periodShort: String {
        let parts = period.components(separatedBy: " - ")
        guard parts.count == 2 else { return period }

        let start = String(parts[0].suffix(5))
        let end = String(parts[1].suffix(5))

        return "\(start) - \(end)"
    }
}
