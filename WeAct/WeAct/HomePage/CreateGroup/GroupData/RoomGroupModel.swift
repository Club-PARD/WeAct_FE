// 보드 내부 정보
import Foundation

struct RoomGroupModel: Equatable, Decodable {
    let roomName: String
    let dayCountByWeek: Int
    let checkPoints: [String]
    let reward: String
    let period: String
    let days: String
}

class RoomGroupService {
    static let shared = RoomGroupService()
    private init() {}
    
    func getRoomDetail(roomId: String, token: String) async throws -> RoomGroupModel {
        // URL 구성
        let urlString = "\(APIConstants.baseURL)\(APIConstants.Room.home)/\(roomId)"
        print("🌐 [getRoomDetail] 요청 URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ [getRoomDetail] 잘못된 URL: \(urlString)")
            throw URLError(.badURL)
        }
        
        // 요청 구성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("🔍 [getRoomDetail] HTTP Method: \(request.httpMethod ?? "nil")")
        print("🔍 [getRoomDetail] Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // HTTP 응답 상태 확인
            if let httpResponse = response as? HTTPURLResponse {
                print("🔍 [getRoomDetail] 응답 상태코드: \(httpResponse.statusCode)")
                print("🔍 [getRoomDetail] 응답 헤더: \(httpResponse.allHeaderFields)")
                
                // 응답 데이터 출력 (처음 500자만)
                if let responseString = String(data: data, encoding: .utf8) {
                    let preview = String(responseString.prefix(500))
                    print("🔍 [getRoomDetail] 응답 데이터 미리보기: \(preview)")
                }
                
                // 상태코드별 상세 에러 처리
                switch httpResponse.statusCode {
                case 200...299:
                    break // 성공
                case 400:
                    print("❌ [getRoomDetail] 400 Bad Request - 잘못된 요청")
                    throw URLError(.badServerResponse)
                case 401:
                    print("❌ [getRoomDetail] 401 Unauthorized - 인증 토큰 문제")
                    throw URLError(.userAuthenticationRequired)
                case 403:
                    print("❌ [getRoomDetail] 403 Forbidden - 권한 없음")
                    throw URLError(.noPermissionsToReadFile)
                case 404:
                    print("❌ [getRoomDetail] 404 Not Found - 존재하지 않는 방 ID: \(roomId)")
                    throw URLError(.fileDoesNotExist)
                case 500...599:
                    print("❌ [getRoomDetail] 서버 오류: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                default:
                    print("❌ [getRoomDetail] 알 수 없는 HTTP 에러: \(httpResponse.statusCode)")
                    throw URLError(.unknown)
                }
            }
            
            // JSON 디코딩
            let roomDetail = try JSONDecoder().decode(RoomGroupModel.self, from: data)
            print("✅ [getRoomDetail] 디코딩 성공")
            return roomDetail
            
        } catch let error as DecodingError {
            print("❌ [getRoomDetail] JSON 디코딩 에러: \(error)")
            throw error
        } catch {
            print("❌ [getRoomDetail] 네트워크 에러: \(error)")
            throw error
        }
    }
}
