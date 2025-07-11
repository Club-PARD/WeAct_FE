import Foundation
import UIKit

class HabitPostService {
    private let networkService = NetworkService.shared
    
    // 습관 인증 업로드 메소드
    func submitHabit(request: HabitRequest, image: UIImage?) async throws {
        // 서버 URL 및 API 엔드포인트 설정
        guard let url = URL(string: APIConstants.baseURL + APIConstants.HabitPost.create) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }
        
        // 액세스 토큰 가져오기
        guard let accessToken = TokenManager.shared.getToken() else {
            throw NSError(domain: "No Access Token", code: 401, userInfo: nil)
        }
        
        // multipart/form-data로 보내기 위한 설정
        let boundary = "Boundary-\(UUID().uuidString)"
        var formData = Data()
        
        // request JSON 추가
        let jsonString = "{\"roomId\": \(request.roomId), \"message\": \"\(request.message)\", \"isHaemyeong\": \(request.isHaemyeong)}"
        print("📤 [습관 인증 request body] \(jsonString)")
        
        formData.append("--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"request\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        formData.append(jsonString.data(using: .utf8) ?? Data())
        formData.append("\r\n".data(using: .utf8)!)
        
        // 이미지가 있을 경우 추가
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.7) {
            formData.append("--\(boundary)\r\n".data(using: .utf8)!)
            formData.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            formData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            formData.append(imageData)
            formData.append("\r\n".data(using: .utf8)!)
        }
        
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // URLRequest 직접 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = formData
        
        // 네트워크 요청 실행
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
    }
}
