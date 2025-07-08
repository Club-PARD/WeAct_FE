//
//  NetworkService.swift
//  WeAct
//
//  Created by 주현아 on 7/8/25.
//
// 공통 HTTP 요청 (토큰 포함 등) 관리

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    // MARK: - 공통 GET 요청
    func get<T: Decodable>(url: URL, accessToken: String? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 GET 응답 코드: \(httpResponse.statusCode)")
        print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - 공통 POST 요청
    func post<T: Decodable, U: Encodable>(url: URL, body: U, accessToken: String? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 POST 응답 코드: \(httpResponse.statusCode)")
        print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // 필요 시 PATCH, DELETE 메서드도 동일 패턴으로 추가
}
