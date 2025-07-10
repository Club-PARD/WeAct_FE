// 보드 내부 정보
import Foundation

struct HamburgerModel: Decodable {
    let myName: String
    let myHabit: String?
    let imageUrl: String?
    let myPercent: Int
    let memberNameAndHabitDtos: [memberNameAndHabit]
}

struct memberNameAndHabit: Decodable {
    let memberName: String
    let memberHabit: String
    let imageUrl: String
}

class HamburgerService {
    static let shared = HamburgerService()
    private init() {}
    
    func getHamburger(roomId: String, token: String) async throws -> HamburgerModel {
        // URL 구성
        let urlString = "\(APIConstants.baseURL)\(APIConstants.MemberInformation.hamburger)/\(roomId)"
        print("🌐 [getHamburger] 요청 URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ [getHamburger] 잘못된 URL: \(urlString)")
            throw URLError(.badURL)
        }
        
        // 요청 구성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("🔍 [getHamburger] HTTP Method: \(request.httpMethod ?? "nil")")
        print("🔍 [getHamburger] Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // HTTP 응답 상태 확인
            if let httpResponse = response as? HTTPURLResponse {
                print("🔍 [getHamburger] 응답 상태코드: \(httpResponse.statusCode)")
                print("🔍 [getHamburger] 응답 헤더: \(httpResponse.allHeaderFields)")
                
                // 응답 데이터 출력 (처음 500자만)
                if let responseString = String(data: data, encoding: .utf8) {
                    let preview = String(responseString.prefix(500))
                    print("🔍 [getHamburger] 응답 데이터 미리보기: \(preview)")
                }
                
                // 상태코드별 상세 에러 처리
                switch httpResponse.statusCode {
                case 200...299:
                    break // 성공
                case 400:
                    print("❌ [getHamburger] 400 Bad Request - 잘못된 요청")
                    throw URLError(.badServerResponse)
                case 401:
                    print("❌ [getHamburger] 401 Unauthorized - 인증 토큰 문제")
                    throw URLError(.userAuthenticationRequired)
                case 403:
                    print("❌ [getHamburger] 403 Forbidden - 권한 없음")
                    throw URLError(.noPermissionsToReadFile)
                case 404:
                    print("❌ [getHamburger] 404 Not Found - 존재하지 않는 방 ID: \(roomId)")
                    throw URLError(.fileDoesNotExist)
                case 500...599:
                    print("❌ [getHamburger] 서버 오류: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                default:
                    print("❌ [getHamburger] 알 수 없는 HTTP 에러: \(httpResponse.statusCode)")
                    throw URLError(.unknown)
                }
            }
            
            // JSON 디코딩
            let hamburgerInfo = try JSONDecoder().decode(HamburgerModel.self, from: data)
            print("✅ [getHamburger] 디코딩 성공")
            return hamburgerInfo
            
        } catch let error as DecodingError {
            print("❌ [getHamburger] JSON 디코딩 에러: \(error)")
            throw error
        } catch {
            print("❌ [getHamburger] 네트워크 에러: \(error)")
            throw error
        }
    }
}
