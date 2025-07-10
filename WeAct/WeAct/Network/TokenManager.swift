import Foundation

class TokenManager {
    static let shared = TokenManager()

    private let tokenKey = "auth_token"

    private init() {}

    // 토큰 저장
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        print("✅ 토큰 저장 완료: \(token)")
    }

    // 토큰 가져오기
    func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        print("📦 저장된 토큰: \(token ?? "없음")")
        return token
    }

    // 토큰 삭제
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        print("🗑️ 토큰 삭제 완료")
    }
}
