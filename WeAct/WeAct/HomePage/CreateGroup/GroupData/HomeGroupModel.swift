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

struct HomeGroupModel: Decodable {
    var roomId: Int
    let roomName: String
    let habit: String
    let period: String
    let dayCountByWeek: Int
    let percent: Int
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
    
    func getHomeGroups(userId: String) async throws -> HomeGroupResponse {
        guard let url = URL(string: "https://naruto.asia/user/home/\(userId)") else {
            print("❌ URL 생성 실패")
            throw URLError(.badURL)
        }
        
        print("📡 [요청 URL] \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("✅ [서버 응답 원본 JSON]\n\(jsonString)")
        } else {
            print("⚠️ [서버 응답] JSON 변환 실패")
        }
        
        do {
            let decodedData = try JSONDecoder().decode(HomeGroupResponse.self, from: data)
            print("✅ [디코딩 성공] 받은 그룹 수: \(decodedData.roomInformationDtos.count)")
            return decodedData
        } catch {
            print("❌ [디코딩 실패] \(error.localizedDescription)")
            throw error
        }
    }
}
