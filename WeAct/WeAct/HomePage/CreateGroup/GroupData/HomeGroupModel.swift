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

struct HomeGroupModel: Identifiable, Decodable {
    var id = UUID()  // 서버에 id 없으니 임시로 UUID 사용
    let roomName: String
    let habit: String
    let period: String
    let dayCountByWeek: Int
    let percent: Int
}

class HomeGroupService {
    static let shared = HomeGroupService()
    
    private init() {}
    
    func getHomeGroups(userId: Int) async throws -> HomeGroupResponse {
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
