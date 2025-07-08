//
//  UserService.swift
//  WeAct
//
//  Created by 주현아 on 7/2/25.
//

import SwiftUI
import Foundation

// MARK: user-post response
struct PartialUserResponse: Codable {
    let id: Int
    let userId: String
}

class UserService {
    
    // MARK: - 아이디 중복 확인 (Boolean 응답 버전)
    func checkUserIdDuplicate(userId: String) async throws -> Bool {
    
//         guard let url = URL(string: "https://naruto.asia/user/checkDuplicated/\(userId)") else {
//             throw URLError(.badURL)
//         }
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.checkDuplicate + "/\(userId)") else {
            throw URLError(.badURL)
        }


        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        print("🌐 [중복확인 요청] \(url.absoluteString)")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ HTTP 응답 아님")
            throw URLError(.badServerResponse)
        }

        print("📡 응답 상태코드: \(httpResponse.statusCode)")
        print("📄 응답 원시 데이터: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "❌ 아이디 중복 확인 실패 (코드 \(httpResponse.statusCode))"])
        }

        do {
            let isDuplicated = try JSONDecoder().decode(Bool.self, from: data)
            print("🔍 최종 파싱 결과: \(isDuplicated)")
            return isDuplicated  // true면 중복, false면 사용 가능
        } catch {
            print("❌ Boolean 디코딩 실패: \(error)")
            throw error
        }
    }

    
    // 사용자 정보 생성
    func createUser(user: UserModel) async throws -> PartialUserResponse {
//
//        guard let url = URL(string: "https://naruto.asia/user/") else {
//            throw URLError(.badURL)
//        }


        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.create) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(user)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "❌ 사용자 생성 실패"])
        }

        let partialUser = try JSONDecoder().decode(PartialUserResponse.self, from: data)
        print("✅ 서버 응답 디코딩 성공: \(partialUser)")
        return partialUser
    }
    
    // MARK: - 로그인 요청
    func login(userId: String, password: String) async throws -> String {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.login) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["userId": userId, "password": password]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 로그인 응답 상태코드: \(httpResponse.statusCode)")
        print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "❌ 로그인 실패"])
        }

        // 예: 응답이 {"accessToken": "abc.def.ghi"}인 경우를 가정
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        return tokenResponse.accessToken
    }

    // 로그인 응답용 구조체
    struct TokenResponse: Codable {
        let accessToken: String
    }


    
 
 
}
