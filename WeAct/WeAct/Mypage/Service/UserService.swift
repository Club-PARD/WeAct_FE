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
    
    // 사용자 정보 생성
    func createUser(user: UserModel) async throws -> PartialUserResponse {
        guard let url = URL(string: "https://naruto.asia/user/") else {
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


    
    // GET: 사용자 데이터 가져오기
    func fetchUsers() async throws -> [UserModel] {
          let url = URL(string: "http://192.168.0.7:8080/user/")! // 스웨거 주소 기반
          
          let (data, response) = try await URLSession.shared.data(from: url)
          
          if let httpResponse = response as? HTTPURLResponse {
              print("📡 응답코드: \(httpResponse.statusCode)")
              print("📦 응답내용: \(String(data: data, encoding: .utf8) ?? "없음")")
          }
          
          let users = try JSONDecoder().decode([UserModel].self, from: data)
          return users
      }
    
    // PATCH: 사용자 이름 수정
    func updateUsername(_ name: String) async throws {
        // 예시 URL (실제 URL로 교체해야 함)
        let url = URL(string: "https://example.com/api/updateUsernameUsername")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 사용자 이름을 JSON 형식으로 요청 본문에 포함
        let body = ["userName": name]
        request.httpBody = try JSONEncoder().encode(body)
        
        // 요청 보내기
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // 성공적으로 응답이 오면 처리 (상태 코드 확인 등)
        if (response as! HTTPURLResponse).statusCode != 200 {
            throw NSError(domain: "com.example", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update username"])
        }
    }
    
    // DELETE: 계정 삭제
    func deleteAccount() async throws {
        // 예시 URL (실제 URL로 교체해야 함)
        let url = URL(string: "https://example.com/api/deleteAccount")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // 요청 보내기
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // 성공적으로 응답이 오면 처리 (상태 코드 확인 등)
        if (response as! HTTPURLResponse).statusCode != 200 {
            throw NSError(domain: "com.example", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete account"])
        }
    }
}
