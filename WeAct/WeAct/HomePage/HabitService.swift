//
//  HabitService.swift
//  WeAct
//
//  Created by 최승아 on 7/10/25.
//

import Foundation

// 올바른 요청 구조 (API 문서 기준)
struct HabitUpdateModel: Codable {
    let roomId: Int
    let habit: String
    let remindTime: String
}

enum HabitServiceError: Error {
    case invalidURL
    case invalidResponse
    case serverError(String)
    case networkError(Error)
}

class HabitService {
    static let shared = HabitService()
    
    func updateHabit(token: String, roomId: Int, habit: String, remindTime: String) async throws {
        
        print("🔍 [HabitService] roomId: \(roomId)")
        print("🔍 [HabitService] habit: \(habit)")
        print("🔍 [HabitService] remindTime: \(remindTime)")
        print("🔍 [HabitService] token: \(token.prefix(20))...")
        
        // 올바른 API 엔드포인트 사용
        guard let url = URL(string: "https://naruto.asia/member/habitAndRemindTime") else {
            throw HabitServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // PATCH가 아니라 POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // API 문서에 따라 body에 roomId 포함
        let body = HabitUpdateModel(roomId: roomId, habit: habit, remindTime: remindTime)
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            
            print("🔍 [Request] URL: \(url)")
            print("🔍 [Request] Method: \(request.httpMethod ?? "Unknown")")
            print("🔍 [Request] Headers: \(request.allHTTPHeaderFields ?? [:])")
            if let bodyString = String(data: jsonData, encoding: .utf8) {
                print("🔍 [Request] Body: \(bodyString)")
            }
            
        } catch {
            print("❌ [Request] JSON 인코딩 실패: \(error)")
            throw HabitServiceError.networkError(error)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🔍 [Response] Status: \(httpResponse.statusCode)")
                print("🔍 [Response] Headers: \(httpResponse.allHeaderFields)")
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("🔍 [Response] Body: \(responseString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HabitServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                print("✅ [Success] 습관 업데이트 성공")
                return
                
            case 400:
                if let responseString = String(data: data, encoding: .utf8) {
                    throw HabitServiceError.serverError("잘못된 요청: \(responseString)")
                } else {
                    throw HabitServiceError.serverError("잘못된 요청입니다. 입력 데이터를 확인해주세요.")
                }
                
            case 401:
                throw HabitServiceError.serverError("인증에 실패했습니다. 다시 로그인해주세요.")
                
            case 403:
                throw HabitServiceError.serverError("권한이 없습니다. 방 멤버인지 확인해주세요.")
                
            case 404:
                throw HabitServiceError.serverError("해당 방을 찾을 수 없습니다.")
                
            case 500...599:
                if let responseString = String(data: data, encoding: .utf8) {
                    throw HabitServiceError.serverError("서버 오류: \(responseString)")
                } else {
                    throw HabitServiceError.serverError("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")
                }
                
            default:
                if let responseString = String(data: data, encoding: .utf8) {
                    throw HabitServiceError.serverError("알 수 없는 오류 (상태 코드: \(httpResponse.statusCode)): \(responseString)")
                } else {
                    throw HabitServiceError.serverError("알 수 없는 오류가 발생했습니다. (상태 코드: \(httpResponse.statusCode))")
                }
            }
            
        } catch {
            if error is HabitServiceError {
                throw error
            } else {
                print("❌ [Network] 네트워크 오류: \(error)")
                throw HabitServiceError.networkError(error)
            }
        }
    }
}

// 에러 처리를 위한 extension
extension HabitServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidResponse:
            return "서버 응답을 처리할 수 없습니다."
        case .serverError(let message):
            return message
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        }
    }
}
