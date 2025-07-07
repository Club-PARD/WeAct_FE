//
//  GroupService.swift
//  WeAct
//
//  Created by 주현아 on 7/7/25.
//
// GroupService.swift
// MARK: 새로 생성된 그룹 정보를 서버에 post하기 위한 코드들

import Foundation

// MARK: - GroupRequest (서버로 보낼 모델)
struct GroupRequest: Encodable {
    let invitedIds: [Int]   // 초대받은 user들 Id
    let roomName: String
    let startDate: String
    let endDate: String
    let reward: String
    let days: String  // 월, 화, 수, 목, 금
    let dayCountByWeek: Int // 주 n회
    let creatorId: Int  // 방 주최자 user id
}

// MARK: - GroupResponse (서버에서 받을 모델)
struct GroupResponse: Decodable {
    let roomId: Int // 방 식별자 아이디, 몇 번째 방
    let roomName: String
    let creatorName: String // 방 주최자 이름
    let userInviteIds: [Int]    // 초대장 아이디들
    let dayCountByWeek: Int
    let checkPoints: [String]
}

extension CreateGroupData {
    // 서버 요청 객체 생성
    func createGroupRequest(invitedIds: [Int], creatorId: Int) -> GroupRequest {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return GroupRequest(
            invitedIds: invitedIds,
            roomName: name,
            startDate: formatter.string(from: startDate),
            endDate: formatter.string(from: endDate),
            reward: reward,
            days: selectedDaysString,
            dayCountByWeek: selectedDaysCount,
            creatorId: creatorId
        )
    }
}

// MARK: - GroupService (서버 통신 담당)
class GroupService {
    static let shared = GroupService()
    private init() {}

    func createGroup(request: GroupRequest) async throws -> GroupResponse {
        guard let url = URL(string: "https://naruto.asia/room") else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonData

        // ✅ [Request Pretty Print]
        if let requestObject = try? JSONSerialization.jsonObject(with: jsonData),
           let prettyRequestData = try? JSONSerialization.data(withJSONObject: requestObject, options: [.prettyPrinted]),
           let prettyRequestString = String(data: prettyRequestData, encoding: .utf8) {
            print("📤 [GroupService] Request Body:\n\(prettyRequestString)\n")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // ✅ HTTP 응답 상태 코드와 응답 데이터 출력
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 HTTP Status Code: \(httpResponse.statusCode)")
                
                // 응답 데이터를 문자열로 출력 (오류 메시지 확인용)
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📋 Response Body: \(responseString)")
                }
                
                // 200-299 범위가 아닌 경우 상세 오류 정보 제공
                if !(200..<300).contains(httpResponse.statusCode) {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("❌ HTTP Error \(httpResponse.statusCode): \(errorMessage)")
                    throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [
                        NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): \(errorMessage)"
                    ])
                }
            }
            
            // ✅ JSON 디코딩 시도
            let decoded = try JSONDecoder().decode(GroupResponse.self, from: data)
            
            // ✅ [Response Pretty Print]
            print("✅ [GroupService] Response:")
            print("""
            ▸ roomId         : \(decoded.roomId)
            ▸ roomName       : \(decoded.roomName)
            ▸ creatorName    : \(decoded.creatorName)
            ▸ userInviteIds  : \(decoded.userInviteIds)
            ▸ dayCountByWeek : \(decoded.dayCountByWeek)
            ▸ checkPoints    :
              \(decoded.checkPoints.joined(separator: "\n  "))
            """)
            
            return decoded
            
        } catch let decodingError as DecodingError {
            print("❌ JSON Decoding Error: \(decodingError)")
            throw decodingError
        } catch {
            print("❌ Network Error: \(error)")
            throw error
        }
    }
}
