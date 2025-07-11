import Foundation
import UIKit

@MainActor
class CertificationViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var image: UIImage? = nil
    @Published var isSubmitting: Bool = false
    @Published var selectedOption: String = "인증할래요"
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
//    @ObservedObject var groupStore: GroupStore
//    @State private var roomDetail: RoomGroupModel?
    private let habitPostService = HabitPostService()

    // 습관 인증 전송
    func submitHabit(roomId: Int) async {
        guard !message.isEmpty else {
            alertMessage = "메시지를 입력해주세요."
            showAlert = true
            return
        }

        let habitRequest = HabitRequest(
            roomId: roomId,  // 실제 roomId로 변경 필요
            message: message,
            isHaemyeong: selectedOption == "해명할래요"
        )

        isSubmitting = true

        do {
            try await habitPostService.submitHabit(request: habitRequest, image: image)
            print("✅ 습관 인증 성공!")
            
            // 성공 시 폼 초기화
            resetForm()
            
            alertMessage = "습관 인증이 성공적으로 게시되었습니다!"
            showAlert = true
            
        } catch {
            print("❌ 습관 인증 실패: \(error)")
            
            alertMessage = "습관 인증 게시에 실패했습니다. 다시 시도해주세요."
            showAlert = true
        }
        
        isSubmitting = false
    }
    
    // 폼 초기화
    private func resetForm() {
        message = ""
        image = nil
        selectedOption = "인증할래요"
    }
}
