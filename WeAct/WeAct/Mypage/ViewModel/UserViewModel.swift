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

    @Published var isShowingImagePicker = false
    
    @Published var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                user.localProfileImage = image
            }
        }
    }

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

    
    // MARK: - 회원가입 (POST)
    func createUser(user: UserModel) async throws -> PartialUserResponse {
        let response = try await service.createUser(user: user)
            return response
    }

    
    // MARK: - 이름 수정 (PATCH)
    func updateUsername(newName: String) async {
        do {
            try await service.updateUsername(newName)
            user.userName = newName
        } catch {
            // 에러 처리 (예: alert 표시 등)
        }
    }
    
    func saveNewName(editedName: String) async {
        await updateUsername(newName: editedName)
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
    
    // 회원탈퇴
}
