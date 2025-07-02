//
//  UserService.swift
//  WeAct
//
//  Created by 주현아 on 7/2/25.
//

import SwiftUI

class UserService {
    
    // GET: 사용자 데이터 가져오기
    func fetchUser() async throws -> User {
        // 예시 URL (실제 URL로 교체해야 함)
        let url = URL(string: "https://example.com/api/user")!
        
        // 데이터 요청
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // 데이터를 User 모델로 변환 (JSON -> User)
        let user = try JSONDecoder().decode(User.self, from: data)
        
        return user  // User 객체 반환
    }
    
    // PATCH: 사용자 이름 수정
    func updateUsername(_ name: String) async throws {
        // 예시 URL (실제 URL로 교체해야 함)
        let url = URL(string: "https://example.com/api/updateUsername")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 사용자 이름을 JSON 형식으로 요청 본문에 포함
        let body = ["username": name]
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
