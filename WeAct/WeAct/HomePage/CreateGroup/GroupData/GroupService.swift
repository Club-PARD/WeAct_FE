// POST한 후 받은 reponse로 내부 보드 들어가기
import Foundation

// MARK: - GroupRequest (서버로 보낼 모델)
struct GroupRequest: Codable {
    let invitedIds: [Int]   // 초대받은 user들 Id
    let roomName: String
    let startDate: String
    let endDate: String
    let reward: String
    let days: String    // "월수금"
    let dayCountByWeek: Int // 주 n회
}

// MARK: - GroupResponse (서버에서 받을 모델)
struct GroupResponse: Codable {
    let creatorName: String // 방 주최자 이름
    let roomId: Int // 방 식별자 아이디, 몇 번째 방
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
        )
    }
}

// MARK: - GroupService (서버 통신 담당)
class GroupService {
    static let shared = GroupService()
    private init() {}

    func createGroup(request: GroupRequest, token: String) async throws -> GroupResponse {
        guard let url = URL(string: "https://naruto.asia/room") else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization"
        
        let jsonData = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonData

        // ✅ 요청 로그
        if let requestObject = try? JSONSerialization.jsonObject(with: jsonData),
           let prettyRequestData = try? JSONSerialization.data(withJSONObject: requestObject, options: [.prettyPrinted]),
           let prettyRequestString = String(data: prettyRequestData, encoding: .utf8) {
            print("📤 [GroupService] Request Body:\n\(prettyRequestString)\n")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 HTTP Status Code: \(httpResponse.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📋 Response Body: \(responseString)")
                }

                if !(200..<300).contains(httpResponse.statusCode) {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [
                        NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): \(errorMessage)"
                    ])
                }
            }
            
            let decoded = try JSONDecoder().decode(GroupResponse.self, from: data)
            
            print("✅ [GroupService] Response:")
            print("""
            ▸ roomId         : \(decoded.roomId)
            ▸ creatorName    : \(decoded.creatorName)
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
