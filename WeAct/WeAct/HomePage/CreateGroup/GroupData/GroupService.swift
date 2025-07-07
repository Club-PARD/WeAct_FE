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
    let invitedIds: [Int]
    let roomName: String
    let startDate: String
    let endDate: String
    let reward: String
    let dayCountByWeek: Int
    let creatorId: Int
}

// MARK: - GroupRequest (서버에서 받을 모델)
struct GroupResponse: Decodable {
    let roomId: Int
    let roomName: String
    let creatorName: String
    let userInviteIds: [Int]
    let dayCountByWeek: Int
    let checkPoints: [String]
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

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // ✅ [Response 디코딩]
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
    }
}
