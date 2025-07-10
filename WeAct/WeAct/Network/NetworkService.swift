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
        
        // 토큰이 있으면 Authorization header 추가
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
            let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "❌ GET 요청 실패 (코드 \(httpResponse.statusCode)): \(errorMessage)"
            ])
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - 공통 POST 요청
    func post<T: Decodable, U: Encodable>(url: URL, body: U, accessToken: String? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 토큰이 있으면 Authorization header 추가
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

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "❌ POST 요청 실패 (코드 \(httpResponse.statusCode)): \(errorMessage)"
            ])
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - 공통 PUT 요청
    func put<T: Decodable, U: Encodable>(url: URL, body: U, accessToken: String? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 토큰이 있으면 Authorization header 추가
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 PUT 응답 코드: \(httpResponse.statusCode)")
        print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "❌ PUT 요청 실패 (코드 \(httpResponse.statusCode)): \(errorMessage)"
            ])
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - 공통 DELETE 요청
    func delete(url: URL, accessToken: String? = nil) async throws -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // 토큰이 있으면 Authorization header 추가
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 DELETE 응답 코드: \(httpResponse.statusCode)")
        print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "❌ DELETE 요청 실패 (코드 \(httpResponse.statusCode)): \(errorMessage)"
            ])
        }

        return true
    }

    // MARK: - Body 없는 POST 요청 (가입, 탈퇴 등)
    func postWithoutBody<T: Decodable>(url: URL, accessToken: String? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 토큰이 있으면 Authorization header 추가
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 POST (no body) 응답 코드: \(httpResponse.statusCode)")
        print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "❌ POST 요청 실패 (코드 \(httpResponse.statusCode)): \(errorMessage)"
            ])
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Body 없는 POST 요청 (Boolean 응답)
    func postWithoutBody(url: URL, accessToken: String? = nil) async throws -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 토큰이 있으면 Authorization header 추가
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 POST (no body, bool) 응답 코드: \(httpResponse.statusCode)")
        print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

        return (200...299).contains(httpResponse.statusCode)
    }
    
    
    // MARK: - Body가 있는 POST 요청 (응답 없음)
       func postWithBodyNoResponse<U: Encodable>(url: URL, body: U, accessToken: String? = nil) async throws -> Bool {
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           // 토큰이 있으면 Authorization header 추가
           if let token = accessToken {
               request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           }

           request.httpBody = try JSONEncoder().encode(body)
           
           // 요청 본문 로깅
           if let bodyData = request.httpBody,
              let bodyString = String(data: bodyData, encoding: .utf8) {
               print("📤 요청 본문: \(bodyString)")
           }

           let (data, response) = try await URLSession.shared.data(for: request)

           guard let httpResponse = response as? HTTPURLResponse else {
               throw URLError(.badServerResponse)
           }

           print("📡 POST (with body, no response) 응답 코드: \(httpResponse.statusCode)")
           print("📦 응답 본문: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")

           guard (200...299).contains(httpResponse.statusCode) else {
               let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
               throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                   NSLocalizedDescriptionKey: "❌ POST 요청 실패 (코드 \(httpResponse.statusCode)): \(errorMessage)"
               ])
           }

           return true
       }
}
