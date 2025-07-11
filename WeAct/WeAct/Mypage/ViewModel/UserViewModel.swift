//
//  UserViewModel.swift
//  WeAct
//
//  Created by 주현아 on 7/2/25.
//

import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: UserModel = UserModel(
        id: nil,
        userId: nil,
        pw: nil,
        userName: "",
        gender: nil,
        profileImageURL: nil
    )
    
    @Published var token: String?
    @Published var isShowingImagePicker = false
    @Published var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                user.localProfileImage = image  // 로컬에 표시
                Task {
                    await uploadProfileImageToServer(image: image)
                }
            }
        }
    }
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service = UserService()
    
    // MARK: - 토큰 새로고침 (수정됨)
    func refreshTokenFromStorage() {
        if let savedToken = TokenManager.shared.getToken() {
            print("🔍 저장된 토큰 불러오기: \(savedToken.prefix(20))...")
            self.token = savedToken
        } else {
            print("❌ 저장된 토큰이 없음")
            self.token = nil
        }
    }
    
    // MARK: - 사용자 정보 가져오기
    func fetchUserInfo() async {
        guard let token = token else {
            print("❌ 토큰이 없어서 사용자 정보를 가져올 수 없습니다")
            return
        }
        
        do {
            print("📝 사용자 정보 가져오기 시작...")
            let userInfo = try await service.getUserInfo(token: token)
            
            await MainActor.run {
                self.user.id = userInfo.id
                self.user.userId = userInfo.userId
                self.user.userName = userInfo.userName ?? ""
                self.user.gender = userInfo.gender
                self.user.profileImageURL = userInfo.profileImageURL
            }
        } catch {
            print("❌ 사용자 정보 가져오기 실패: \(error)")
            await MainActor.run {
                self.errorMessage = "사용자 정보를 불러올 수 없습니다"
            }
        }
    }
    

    // ✅ 간단 프로필 정보만 가져오기 (이름, 이미지)
    func fetchSimpleProfile() async {
        guard let token = token else {
            print("❌ 토큰 없음 - 프로필 조회 불가")
            return
        }

        do {
            let (userName, profileImageURL) = try await service.getCurrentUserProfile(token: token) ?? ("", "")
            
            await MainActor.run {
                self.user.userName = userName
                self.user.profileImageURL = profileImageURL
                self.user.localProfileImage = nil // ✅ 로컬 이미지 제거 후 서버 이미지 표시
            }
        } catch {
            print("❌ 간단 프로필 가져오기 실패: \(error)")
        }
    }

    // MARK: - 아이디 중복 확인
    func isUserIdDuplicated(_ userId: String) async -> Bool? {
        do {
            return try await service.checkUserIdDuplicate(userId: userId)
        } catch {
            print("❌ 중복 확인 에러: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - 로그인 처리 (수정됨)
    func login(userId: String, password: String) async {
        do {
            print("🔑 로그인 시도 중...")
            print("🔑 로그인 데이터: userId=\(userId), password=\(password)")
            
            let token = try await service.login(userId: userId, password: password)
            print("✅ 로그인 성공, 토큰: \(token.prefix(20))...")
            
            // 로그인 성공 처리
            await handleLoginSuccess(token: token, userId: userId)
            
        } catch {
            print("❌ 로그인 실패: \(error)")
            handleLoginError(error)
        }
    }
    
    // MARK: - 회원가입 + 로그인 처리 (수정됨)
    func createUserAndLogin() async {
        guard let userId = user.userId,
              let pw = user.pw else {
            errorMessage = "아이디와 비밀번호를 입력해주세요."
            return
        }
        
        do {
            // 1. 회원가입 요청
            print("📝 회원가입 시도 중...")
            print("📝 회원가입 데이터: userId=\(userId), pw=\(pw), userName=\(user.userName)")
            try await service.createUser(user: user)
            print("✅ 회원가입 성공")
            
            // 🔥 2. 회원가입 후 약간의 딜레이 추가 (서버 동기화 대기)
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5초 대기
            
            // 3. 로그인 시도
            await login(userId: userId, password: pw)
            
        } catch {
            print("❌ 회원가입 실패: \(error)")
            handleLoginError(error)
        }
    }
    
    // MARK: - 로그인 성공 처리 (완전 수정됨)
    func handleLoginSuccess(token: String, userId: String) async {
        print("🔐 로그인 성공 - 토큰 및 사용자 정보 갱신 시작")
        
        // 🔥 1. 기존 데이터 완전 초기화
        await MainActor.run {
            // 기존 토큰 및 사용자 정보 완전 삭제
            TokenManager.shared.logout()
            
            // 사용자 정보 초기화
            self.user = UserModel(
                id: nil,
                userId: userId,  // 로그인한 사용자 ID만 설정
                pw: nil,
                userName: "",
                gender: nil,
                profileImageURL: nil
            )
            
            // 에러 메시지 초기화
            self.errorMessage = nil
        }
        
        // 🔥 2. 새 토큰 저장 및 설정
        print("📦 새 토큰 저장 시작...")
        TokenManager.shared.saveToken(token)
        TokenManager.shared.saveUserId(userId)
        
        await MainActor.run {
            self.token = token
            self.isLoggedIn = true
        }
        
        print("✅ 토큰 저장 완료")
        
        // 🔥 3. 서버에서 최신 사용자 정보 가져오기
        await fetchUserInfo()
        
        print("✅ 로그인 성공 처리 완료")
    }
    
    // MARK: - 로그인 에러 처리
    func handleLoginError(_ error: Error) {
        print("❌ 에러 발생: \(error)")
        
        if let nsError = error as NSError? {
            switch nsError.code {
            case 400:
                errorMessage = "요청 데이터가 올바르지 않습니다."
            case 401:
                errorMessage = "아이디 또는 비밀번호가 잘못되었습니다."
            case 404:
                errorMessage = "사용자를 찾을 수 없습니다."
            case 409:
                errorMessage = "이미 존재하는 사용자입니다."
            case 500:
                errorMessage = "서버 오류가 발생했습니다."
            default:
                errorMessage = "알 수 없는 오류: \(nsError.localizedDescription)"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - 로그아웃 처리 (수정됨)
    func handleLogout() {
        print("🔐 로그아웃 시작")
        
        // 1. 토큰 완전 삭제
        TokenManager.shared.logout()
        
        // 2. 사용자 정보 완전 초기화
        self.user = UserModel(
            id: nil,
            userId: nil,
            pw: nil,
            userName: "",
            gender: nil,
            profileImageURL: nil
        )
        
        // 3. 기타 상태 초기화
        self.token = nil
        self.selectedImage = nil
        self.errorMessage = nil
        
        // 4. 로그인 상태 업데이트
        self.isLoggedIn = false
        
        print("✅ 로그아웃 완료")
    }
    
    // MARK: - 앱 시작 시 로그인 상태 확인 (수정됨)
    func checkLoginStatus() async {
        print("🔍 앱 시작 시 로그인 상태 확인")
        
        // 저장된 토큰 확인
        if let savedToken = TokenManager.shared.getToken(),
           TokenManager.shared.isTokenValid() {
            
            print("📦 저장된 유효한 토큰 발견: \(savedToken.prefix(20))...")
            
            // 토큰 설정
            await MainActor.run {
                self.token = savedToken
                self.isLoggedIn = true
            }
            
            // 사용자 정보 가져오기
            await fetchUserInfo()
            
        } else {
            print("❌ 유효한 토큰이 없음 - 로그아웃 처리")
            
            // 무효한 토큰 정리
            TokenManager.shared.logout()
            
            await MainActor.run {
                self.token = nil
                self.isLoggedIn = false
                self.user = UserModel(
                    id: nil,
                    userId: nil,
                    pw: nil,
                    userName: "",
                    gender: nil,
                    profileImageURL: nil
                )
            }
        }
    }
    
    // MARK: - 사용자 탈퇴 처리
    func deleteUser() async {
        guard let token = token else {
            print("❌ 토큰이 없어서 사용자 삭제할 수 없습니다")
            return
        }
            
        do {
            // 1. 사용자 삭제 요청
            let success = try await service.deleteUser(token: token)
            
            if success {
                // 2. 삭제 후 사용자 정보 초기화
                await MainActor.run {
                    self.user = UserModel(id: nil, userId: nil, pw: nil, userName: "", gender: nil, profileImageURL: nil)
                    self.token = nil
                    self.isLoggedIn = false
                    self.errorMessage = nil
                }
                // 3. 로그아웃 처리
                TokenManager.shared.logout()
                print("✅ 사용자 탈퇴 성공")
            }
        } catch {
            print("❌ 사용자 탈퇴 실패: \(error)")
            await MainActor.run {
                self.errorMessage = "사용자 탈퇴에 실패했습니다."
            }
        }
    }
    

    
    // MARK: - 프로필 이미지 관련
    func updateProfileImage(image: UIImage) {
        selectedImage = image
        // 서버 업로드 로직이 필요한 경우 여기에 추가
    }
    
    // MARK: - 프로필 이미지 서버 업로드
    func uploadProfileImageToServer(image: UIImage) async {
          guard let token = TokenManager.shared.getToken() else {
              print("❌ TokenManager에서 토큰을 가져오지 못했습니다")
              return
          }

          do {
              print("📤 프로필 이미지 업로드 시작")
              try await service.uploadProfileImage(image: image, token: token)
              print("✅ 프로필 이미지 업로드 성공")

              // 🔁 이미지 업로드 후 최신 사용자 프로필 반영
              await fetchUserInfo()

          } catch {
              print("❌ 프로필 이미지 업로드 실패: \(error)")
              await MainActor.run {
                  self.errorMessage = "프로필 이미지 업로드에 실패했습니다"
              }
          }
      }

    
    func changeProfileImage() {
        isShowingImagePicker = true
    }
    
    func goToNameEdit() {
        // 화면 전환 트리거용 함수 (View에서 사용)
    }
}
