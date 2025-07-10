import SwiftUI
import Foundation

// 회원가입 응답 구조체 (서버가 토큰 반환)
struct SignUpResponse: Codable {}

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
    let userName: String
    let gender: String?
    let userId: String?
    let pw: String?
}

// 사용자 삭제 응답 구조체
struct UserDeleteResponse: Codable {
    let success: Bool
    let message: String?
}

class UserService {
    private let networkService = NetworkService.shared
    
    // MARK: - 사용자 정보 생성 (회원가입) - 토큰 반환
    func createUser(user: UserModel) async throws {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.create) else {
            throw URLError(.badURL)
        }
        
        print("🌐 [회원가입 요청] \(url.absoluteString)")
        print("📤 [회원가입 요청 데이터] \(user)")
        
        do {
            let cleanedUser = cleanUserModel(user)
            let _: SignUpResponse = try await networkService.post(url: url, body: cleanedUser)
            
            print("✅ 회원가입 성공")
            // 토큰이 없으므로 저장 생략
            
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
        return tokenResponse.token
    }
    
    // MARK: - 사용자 정보 가져오기, 배열로
    func getUserInfo(token: String) async throws -> UserModel {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.User.userInfo) else {
            throw URLError(.badURL)
        }

        // ✅ 응답을 배열로 받기
        let users: [UserModel] = try await networkService.get(url: url, accessToken: token)

        // ✅ 배열 중 첫 번째 유저 사용
        guard let firstUser = users.first else {
            throw NSError(domain: "", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "사용자 정보를 불러올 수 없습니다."
            ])
        }

        return firstUser
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
    
    // MARK: - 홈 그룹 정보 조회 (GET /user/home)
    func getHomeGroups(token: String) async throws -> HomeGroupResponse {
        guard let url = URL(string: APIConstants.baseURL + "/user/home") else {
            throw URLError(.badURL)
        }

        print("🌐 [홈 그룹 조회 요청] \(url.absoluteString)")
        
        // 토큰을 accessToken 파라미터로 넘겨서 GET 요청
        let response: HomeGroupResponse = try await networkService.get(url: url, accessToken: token)
        
        print("✅ 홈 그룹 조회 성공")
        return response
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
        let token : String
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
}
