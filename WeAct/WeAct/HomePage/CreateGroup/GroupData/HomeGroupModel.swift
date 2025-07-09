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
        // 1) 토큰 가져오기
        guard let token = TokenManager.shared.getToken() else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // 2) userId 인코딩
        guard let encodedUserId = userId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw URLError(.badURL)
        }
        
        // 3) URL 생성
        let urlString = "https://naruto.asia/user/home/\(encodedUserId)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // 4) URLRequest 준비
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 5) 헤더에 토큰과 Accept 설정
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 6) 비동기 데이터 요청
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // (선택) 상태 코드와 응답 로그 출력
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 [HTTP 상태] \(httpResponse.statusCode)")
        }
        if let json = String(data: data, encoding: .utf8) {
            print("✅ [서버 응답 원본 JSON] \(json)")
        }
        
        // 7) JSON 파싱 후 반환
        return try JSONDecoder().decode(HomeGroupResponse.self, from: data)
    }
}
