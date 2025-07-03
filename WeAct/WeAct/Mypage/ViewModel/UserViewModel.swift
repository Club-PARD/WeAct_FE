//
//  UserViewModel.swift
//  WeAct
//
//  Created by 주현아 on 7/2/25.
//
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user: User = User(username: "", profileImageURL: nil)
    @Published var isShowingImagePicker = false
    @Published var selectedImage: UIImage?
    
    //목데이터
    init() {
        self.user = User.sampleUser
    }

    
    private let service = UserService()
    
    
    // 프로필 이미지 업데이트
   func updateProfileImage(image: UIImage) {
       // 이미지를 서버에 업로드하고 URL을 저장하는 로직 (예시)
       selectedImage = image
       
   }
    
    
    // 프로필사진 변경
    func changeProfileImage() {
        isShowingImagePicker = true
    }
    
    // 이름 변경 화면으로 이동
    func goToNameEdit() {
        // 네비게이션을 ViewModel에서 처리하기 보다는, 이 값이 변경되면 View에서 화면을 전환하는 방식
    }
    
    // 이름 변경 버튼 눌렀을 때 로직
    func updateUsername(newName: String) async {
        do {
            // 서버로 이름 업데이트 요청
            try await service.updateUsername(newName)
            user.username = newName
        } catch {
            // 에러 처리
        }
    }
    
    // 이름 저장하기 버튼 눌렀을 때 로직
    func saveNewName(editedName: String) async {
        do {
            try await service.updateUsername(editedName)
            user.username = editedName  // 사용자 이름 업데이트
        } catch {
            // 에러 처리 (예: 네트워크 오류)
        }
    }

    
    // 내 습관 기록
    
    // 로그아웃
    
    // 회원탈퇴
    
}
