//
//  CheckPointMember.swift
//  WeAct
//
//  Created by 최승아 on 7/8/25.
//

import SwiftUI

struct CheckPointResponse: Codable, Identifiable {
    let id = UUID()
    let firstRanker: [CheckPointMember]
    let secondRanker: [CheckPointMember]
    let restMembers: [CheckPointMember]?
}

struct CheckPointMember: Codable {
    let userName: String
    let profileImage: String?
}

class CheckPointService {
    static let shared = CheckPointService()
    
    private init() {}
    
    func fetchCheckPoint(roomId: Int) async throws -> CheckPointResponse {
        print("🔍 [중간점검] fetchCheckPoint 호출됨")
        print("📡 [중간점검] roomId: \(roomId)")
        
        guard let url = URL(string: "https://naruto.asia/room/checkPoint/\(roomId)") else {
            print("❌ [중간점검] URL 생성 실패")
            throw URLError(.badURL)
        }

        guard let token = TokenManager.shared.getToken() else {
            print("❌ [중간점검] 액세스 토큰 없음")
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("🚀 [중간점검] API 요청 시작 with token")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📊 [중간점검] 응답 상태 코드: \(httpResponse.statusCode)")
            print("📋 [중간점검] 응답 헤더: \(httpResponse.allHeaderFields)")
        }
        
        print("📦 [중간점검] 응답 데이터 크기: \(data.count) bytes")

        if let jsonString = String(data: data, encoding: .utf8) {
            print("📝 [중간점검] 원시 응답: '\(jsonString)'")
        }

        print("🔧 [중간점검] JSON 파싱 시작...")
        let checkPoint = try JSONDecoder().decode(CheckPointResponse.self, from: data)
        
        return checkPoint
    }

}
