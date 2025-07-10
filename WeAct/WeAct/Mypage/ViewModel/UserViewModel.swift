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
    func createUserAndLogin() async {
        guard let userId = user.userId,
              let pw = user.pw else {
            errorMessage = "아이디와 비밀번호를 입력해주세요."
            return
        }

        do {
            // 1. 회원가입 요청 (토큰 반환하지 않음)
            try await service.createUser(user: user)
            
            // 2. 회원가입 후 로그인하여 토큰 받기
            let token = try await service.login(userId: userId, password: pw)
            
            // 3. 토큰 저장
            TokenManager.shared.saveToken(token)
            print("💾 토큰 저장 완료")

            // 4. 로그인 상태 전환
            isLoggedIn = true
            print("✅ 회원가입 및 자동 로그인 완료")
            
        } catch {
            print("❌ 회원가입/로그인 실패: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
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
