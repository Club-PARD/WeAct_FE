//
//  UserSearchService.swift
//  WeAct
//
//  Created by 주현아 on 7/5/25.
//
// MARK: search관련 서버 통신 코드 현)searchUser

import Foundation

// 서버 응답 모델
struct UserSearchResponse: Codable, Identifiable, Hashable {
    let id: Int
    let userId: String
}

// 서버 통신 관련 서비스 클래스
class UserSearchService {
    static let shared = UserSearchService()
    private init() {}

    // 사용자 검색 (userId 포함 필터)
    func searchUsers(containing keyword: String) async throws -> [UserSearchResponse] {
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://192.168.0.7:8080/user/search/\(encodedKeyword)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode([UserSearchResponse].self, from: data)
        return decoded
    }

    // TODO: 사용자 프로필 이미지 등 상세 정보 조회 함수도 여기에 추가 가능
    
}
