//
//  RoomInfoList.swift
//  WeAct
//
//  Created by 최승아 on 7/7/25.
//

import Foundation

struct HomeGroupResponse: Decodable {
    let month: Int
    let day: Int
    let roomInformationDtos: [HomeGroupModel]
}

struct HomeGroupModel: Decodable { // roomInformationDtos의 [HomeGroupModel]
    let roomName: String
    let habit: String?  // null 값 허용
    let period: String
    let dayCountByWeek: Int
    let percent: Int
    let memberCount: Int
    let roomId: Int
}

extension HomeGroupModel {
    var isCheckPointTime: Bool {
        let result = percent >= 50 && percent < 60
        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검시점=\(result)")
        return result
    }
    
    var isCheckPointPassed: Bool {
        let result = percent >= 60
        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검완료=\(result)")
        return result
    }
    
    var isBeforeCheckPoint: Bool {
        let result = percent < 50
        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검전=\(result)")
        return result
    }
}

class HomeGroupService {
    static let shared = HomeGroupService()
    private init() {}
    
    func getHomeGroups(token: String) async throws -> HomeGroupResponse {
        guard let url = URL(string: APIConstants.baseURL + "/user/home") else {
            throw URLError(.badURL)
        }

        return try await NetworkService.shared.get(url: url, accessToken: token)
    }
}
