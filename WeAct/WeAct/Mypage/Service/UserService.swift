import SwiftUI
import Foundation

// 회원가입 응답 구조체 (서버가 토큰 반환)
struct SignUpResponse: Codable {
    let token: String
}

struct PartialUserResponse: Codable {
    let id: Int?
    let userId: String?
    let token: String? // 서버가 토큰을 반환할 수 있음
}

// 사용자 프로필 응답 구조체
struct UserProfileResponse: Codable {
    let id: Int?
    let userId: String?
    let userName: String?
    let gender: String?
    let profileImageUrl: String?
    let createdAt: String?
    let updatedAt: String?
}

// 사용자 프로필 업데이트 요청 구조체
struct UserProfileUpdateRequest: Codable {
    let userName: String?
    let gender: String?
}

// 사용자 삭제 응답 구조체
struct UserDeleteResponse: Codable {
    let success: Bool
    let message: String?
}

class UserService {
    private let networkService = NetworkService.shared
    
    // MARK: - 사용자 정보 생성 (회원가입) - 토큰 반환
    func createUser(user: UserModel) async throws -> String {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.create) else {
            throw URLError(.badURL)
        }

        print("🌐 [회원가입 요청] \(url.absoluteString)")
        print("📤 [회원가입 요청 데이터] \(user)")
        
        do {
            let cleanedUser = cleanUserModel(user)
            let signUpResponse: SignUpResponse = try await networkService.post(url: url, body: cleanedUser)
            
            print("✅ 회원가입 성공, 토큰 수신: \(signUpResponse.token)")
            return signUpResponse.token
            
        } catch {
            print("❌ 회원가입 실패: \(error)")
            
            if let nsError = error as NSError? {
                switch nsError.code {
                case 400:
                    throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "입력 데이터가 올바르지 않습니다."])
                case 409:
                    throw NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "이미 존재하는 사용자입니다."])
                case 500:
                    throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "서버 오류가 발생했습니다."])
                default:
                    throw error
                }
            }
            throw error
        }
    }
    
    // MARK: - 사용자 ID 중복 확인
    func checkUserIdDuplicate(userId: String) async throws -> Bool {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.checkDuplicate + "/\(userId)") else {
            throw URLError(.badURL)
        }

        print("🌐 [중복확인 요청] \(url.absoluteString)")
        
        return try await networkService.get(url: url)
    }
    
    // MARK: - 로그인
    func login(userId: String, password: String) async throws -> String {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.login) else {
            throw URLError(.badURL)
        }

        let body = LoginRequest(userId: userId, password: password)
        
        print("🌐 [로그인 요청] \(url.absoluteString)")
        
        let tokenResponse: TokenResponse = try await networkService.post(url: url, body: body)
        return tokenResponse.accessToken
    }
    
    // MARK: - 사용자 정보 가져오기 (기존 메서드 - 호환성 유지)
    func getUserInfo(token: String) async throws -> UserModel {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.userInfo) else {
            throw URLError(.badURL)
        }
        
        do {
            let userInfo: UserModel = try await networkService.get(url: url, accessToken: token)
            return userInfo
        } catch {
            if let nsError = error as NSError?, nsError.code == 401 {
                throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 만료되었습니다"])
            }
            throw error
        }
    }
    
    // MARK: - 사용자 프로필 조회 (GET /user/profile)
    func getUserProfile(token: String) async throws -> UserProfileResponse {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.profile) else {
            throw URLError(.badURL)
        }
        
        print("🌐 [프로필 조회 요청] \(url.absoluteString)")
        
        do {
            let profile: UserProfileResponse = try await networkService.get(url: url, accessToken: token)
            print("✅ 프로필 조회 성공")
            return profile
        } catch {
            print("❌ 프로필 조회 실패: \(error)")
            if let nsError = error as NSError?, nsError.code == 401 {
                throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 만료되었습니다"])
            }
            throw error
        }
    }
    
    // MARK: - 사용자 프로필 업데이트 (PATCH /user)
    func updateUserProfile(token: String, userName: String?, gender: String?) async throws -> UserProfileResponse {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.update) else {
            throw URLError(.badURL)
        }
        
        let updateRequest = UserProfileUpdateRequest(userName: userName, gender: gender)
        
        print("🌐 [프로필 업데이트 요청] \(url.absoluteString)")
        print("📤 [업데이트 데이터] \(updateRequest)")
        
        do {
            let updatedProfile: UserProfileResponse = try await networkService.put(url: url, body: updateRequest, accessToken: token)
            print("✅ 프로필 업데이트 성공")
            return updatedProfile
        } catch {
            print("❌ 프로필 업데이트 실패: \(error)")
            if let nsError = error as NSError?, nsError.code == 401 {
                throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 만료되었습니다"])
            }
            throw error
        }
    }
    
    // MARK: - 사용자 탈퇴 (DELETE /user)
    func deleteUser(token: String) async throws -> Bool {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.delete) else {
            throw URLError(.badURL)
        }
        
        print("🌐 [사용자 탈퇴 요청] \(url.absoluteString)")
        
        do {
            let success = try await networkService.delete(url: url, accessToken: token)
            print("✅ 사용자 탈퇴 성공")
            return success
        } catch {
            print("❌ 사용자 탈퇴 실패: \(error)")
            if let nsError = error as NSError?, nsError.code == 401 {
                throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 만료되었습니다"])
            }
            throw error
        }
    }
    
    // MARK: - 사용자 검색 (GET /user/search/{userId})
    func searchUser(userId: String, token: String) async throws -> UserProfileResponse {
        guard let url = URL(string: APIConstants.baseURL + "/user/search/\(userId)") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [사용자 검색 요청] \(url.absoluteString)")
        
        do {
            let userProfile: UserProfileResponse = try await networkService.get(url: url, accessToken: token)
            print("✅ 사용자 검색 성공")
            return userProfile
        } catch {
            print("❌ 사용자 검색 실패: \(error)")
            if let nsError = error as NSError?, nsError.code == 404 {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "사용자를 찾을 수 없습니다"])
            }
            throw error
        }
    }
    
    // MARK: - 사용자 친구 추가 (GET /user/search/add/{userId})
    func addFriend(userId: String, token: String) async throws -> Bool {
        guard let url = URL(string: APIConstants.baseURL + "/user/search/add/\(userId)") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [친구 추가 요청] \(url.absoluteString)")
        
        do {
            let success: Bool = try await networkService.get(url: url, accessToken: token)
            print("✅ 친구 추가 성공")
            return success
        } catch {
            print("❌ 친구 추가 실패: \(error)")
            if let nsError = error as NSError?, nsError.code == 409 {
                throw NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "이미 친구입니다"])
            }
            throw error
        }
    }
    
    // MARK: - 사용자 홈 정보 조회 (GET /user/home)
    func getUserHome(token: String) async throws -> UserHomeResponse {
        guard let url = URL(string: APIConstants.baseURL + "/user/home") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [홈 정보 조회 요청] \(url.absoluteString)")
        
        do {
            let homeInfo: UserHomeResponse = try await networkService.get(url: url, accessToken: token)
            print("✅ 홈 정보 조회 성공")
            return homeInfo
        } catch {
            print("❌ 홈 정보 조회 실패: \(error)")
            if let nsError = error as NSError?, nsError.code == 401 {
                throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 만료되었습니다"])
            }
            throw error
        }
    }
    
    // MARK: - 프로필 사진 업로드 (POST /user/profile-photo)
    func uploadProfilePhoto(token: String, imageData: Data) async throws -> ProfilePhotoResponse {
        guard let url = URL(string: APIConstants.baseURL + "/user/profile-photo") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [프로필 사진 업로드 요청] \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"profilePhoto\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "프로필 사진 업로드 실패: \(errorMessage)"
                ])
            }
            
            let photoResponse = try JSONDecoder().decode(ProfilePhotoResponse.self, from: data)
            print("✅ 프로필 사진 업로드 성공")
            return photoResponse
            
        } catch {
            print("❌ 프로필 사진 업로드 실패: \(error)")
            throw error
        }
    }
    
    // MARK: - UserModel 정리 함수 (Codable 구조체로 변경)
    private func cleanUserModel(_ user: UserModel) -> CleanedUserData {
        return CleanedUserData(
            userName: user.userName,
            userId: user.userId,
            pw: user.pw,
            gender: user.gender
        )
    }
    
    // MARK: - 정리된 사용자 데이터 구조체
    private struct CleanedUserData: Codable {
        let userName: String?
        let userId: String?
        let pw: String?
        let gender: String?
    }
    
    // MARK: - 요청/응답 구조체들
    private struct LoginRequest: Codable {
        let userId: String
        let password: String
    }
    
    struct TokenResponse: Codable {
        let accessToken: String
    }
    
    struct UserHomeResponse: Codable {
        let userName: String?
        let userId: String?
        let profileImageUrl: String?
        let recentActivities: [Activity]?
        let friendsCount: Int?
        let groupsCount: Int?
    }
    
    struct Activity: Codable {
        let id: Int?
        let type: String?
        let title: String?
        let description: String?
        let createdAt: String?
    }
    
    struct ProfilePhotoResponse: Codable {
        let success: Bool
        let imageUrl: String?
        let message: String?
    }
}
