import Foundation

// MARK: - TokenManager
class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "auth_token"
    private let userIdKey = "user_id"
    
    private init() {}
    
    // MARK: - Token Operations
    
    /// 토큰 저장
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.synchronize()
        print("🔐 토큰 저장 성공")
        if let decoded = decodeJWT(token) {
            print("📦 저장된 토큰 정보 - 사용자: \(decoded["sub"] ?? "unknown")")
        }
    }
    
    /// 토큰 불러오기
    func loadToken() -> String? {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        if let token = token {
            print("🔍 토큰 불러오기 성공")
            if let decoded = decodeJWT(token) {
                print("📦 불러온 토큰 정보 - 사용자: \(decoded["sub"] ?? "unknown")")
            }
        } else {
            print("❌ 토큰 불러오기 실패: 저장된 토큰 없음")
        }
        return token
    }
    
    /// 토큰 가져오기
    func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        print("📦 저장된 토큰: \(token ?? "없음")")
        return token
    }
    
    /// 토큰 삭제
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.synchronize()
        print("🗑️ 토큰 삭제 완료")
    }
    
    /// 토큰 유효성 검사
    func isTokenValid() -> Bool {
        guard let token = getToken() else { return false }
        
        if let decoded = decodeJWT(token),
           let exp = decoded["exp"] as? TimeInterval {
            let currentTime = Date().timeIntervalSince1970
            return currentTime < exp
        }
        
        return false
    }
    
    // MARK: - User ID Operations
    
    /// 사용자 ID 저장
    func saveUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
        UserDefaults.standard.synchronize()
        print("📦 사용자 ID 저장: \(userId)")
    }
    
    /// 사용자 ID 불러오기
    func loadUserId() -> String? {
        let userId = UserDefaults.standard.string(forKey: userIdKey)
        if let userId = userId {
            print("🔍 사용자 ID 불러오기: \(userId)")
        }
        return userId
    }
    
    /// 사용자 ID 삭제
    func deleteUserId() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.synchronize()
        print("🗑️ 사용자 ID 삭제 완료")
    }
    
    // MARK: - Complete Logout
    
    /// 완전 로그아웃 (토큰 + 사용자 ID 삭제)
    func logout() {
        deleteToken()
        deleteUserId()
        print("🚪 완전 로그아웃 완료")
    }
    
    /// 로그인 처리 (토큰 + 사용자 ID 저장)
    func loginWithToken(_ token: String, userId: String) {
        print("🔐 로그인 시작 - 기존 토큰 삭제 후 새 토큰 저장")
        
        // 기존 토큰 삭제
        deleteToken()
        deleteUserId()
        
        // 새 토큰 저장
        saveToken(token)
        saveUserId(userId)
        
        print("✅ 로그인 완료")
    }
    
    // MARK: - JWT Decoding
    
    private func decodeJWT(_ token: String) -> [String: Any]? {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else { return nil }
        
        let payload = parts[1]
        let paddedPayload = payload.padding(toLength: ((payload.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        
        guard let data = Data(base64Encoded: paddedPayload),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        return json
    }
}
