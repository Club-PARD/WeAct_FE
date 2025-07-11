//
//  HabitPostService.swift
//  WeAct
//
//  Created by 주현아 on 7/11/25.
//

import Foundation

class HabitBoardService {
    static let shared = HabitBoardService()
    private init() {}

    func fetchHabitPosts(roomId: Int, date: Date, token: String) async throws -> [HabitBoardResponse] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let urlString = "\(APIConstants.baseURL)/habit-post?roomId=\(roomId)&date=\(dateString)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        return try await NetworkService.shared.get(url: url, accessToken: token)
    }
    
    /// 특정 postId에 대한 인증 상세 정보 조회
    func fetchPostDetail(postId: Int, token: String) async throws -> HabitPostDetailResponse {
        let urlString = "\(APIConstants.baseURL)\(APIConstants.HabitPost.getOne)?postId=\(postId)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // ✅ 토큰 헤더 추가

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(HabitPostDetailResponse.self, from: data)
    }

}
