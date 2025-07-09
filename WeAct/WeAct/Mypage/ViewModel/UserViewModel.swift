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
    
    @Published var token: String? = nil
    @Published var isShowingImagePicker = false
    @Published var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                user.localProfileImage = image
            }
        }
    }
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service = UserService()
    
    // MARK: - 아이디 중복 확인
    func isUserIdDuplicated(_ userId: String) async -> Bool? {
        do {
            return try await service.checkUserIdDuplicate(userId: userId)
        } catch {
            print("❌ 중복 확인 에러: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - 회원가입 + 로그인 처리
//    func createUserAndLogin() async {
//        guard let userId = user.userId,
//              let pw = user.pw else {
//            errorMessage = "아이디와 비밀번호를 입력해주세요."
//            return
//        }
//
//        do {
//            // 1. 회원가입 요청 (토큰 반환하지 않음)
//            try await service.createUser(user: user)
//            
//            // 2. 회원가입 후 로그인하여 토큰 받기
//            let token = try await service.login(userId: userId, password: pw)
//            
//            // 3. 토큰 저장
//            TokenManager.shared.saveToken(token)
//
//            // 4. 로그인 상태 전환
//            isLoggedIn = true
//
//            print("✅ 회원가입 및 자동 로그인 완료")
//        } catch {
//            print("❌ 회원가입/로그인 실패: \(error.localizedDescription)")
//            errorMessage = error.localizedDescription
//        }
//    }
    
    // MARK: - 회원가입 + 로그인 처리
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
            
            // 2. 로그인 시도
            print("🔑 로그인 시도 중...")
            print("🔑 로그인 데이터: userId=\(userId), password=\(pw)")
            let token = try await service.login(userId: userId, password: pw)
            print("✅ 로그인 성공, 토큰: \(token.prefix(20))...")
            
            // 3. 토큰 저장
            TokenManager.shared.saveToken(token)
            print("💾 토큰 저장 완료")

            // 4. 로그인 상태 전환
            isLoggedIn = true
            print("✅ 회원가입 및 자동 로그인 완료")
            
        } catch {
            print("❌ 에러 발생 위치 확인:")
            print("❌ 에러 타입: \(type(of: error))")
            print("❌ 에러 메시지: \(error.localizedDescription)")
            print("❌ 상세 에러: \(error)")
            
            // NSError인 경우 상태 코드 확인
            if let nsError = error as NSError? {
                print("❌ 에러 도메인: \(nsError.domain)")
                print("❌ 에러 코드: \(nsError.code)")
                print("❌ 에러 정보: \(nsError.userInfo)")
                
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
    }
    
    
    // MARK: - 프로필 이미지 관련
    func updateProfileImage(image: UIImage) {
        selectedImage = image
        // 서버 업로드 로직이 필요한 경우 여기에 추가
    }
    
    func changeProfileImage() {
        isShowingImagePicker = true
    }
    
    func goToNameEdit() {
        // 화면 전환 트리거용 함수 (View에서 사용)
    }
    
    // MARK: - TODO
    // 내 습관 기록
    
    // 로그아웃
    func logout() {
        TokenManager.shared.deleteToken()
        isLoggedIn = false
        print("✅ 로그아웃 완료")
    }
    
    // 회원탈퇴
}
