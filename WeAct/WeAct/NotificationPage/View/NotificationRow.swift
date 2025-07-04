

import SwiftUI

struct NotificationRow: View {

    var item: NotificationType
    @Binding var selectedImage: UIImage?
    var onReject: () -> Void
    
    
    var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5){
                    Text(mainText)
                        .font(
                        Font.custom("Pretendard", size: 16)
                        .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                    
                    
                    if let subtitle = subtitleText {
                        Text(subtitle)
                            .font(
                            Font.custom("Pretendard", size: 14)
                            .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.53))
                    }
            
                }//VStack

                Spacer()
                
                if case .groupInvite = item {
                    Button(action: {
                        print("그룹에 초대되셨습니다")
                    }) {
                        Text("수락")
                            .font(Font.custom("Pretendard", size: 14).weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundColor(Color(red: 0.2, green: 0.44, blue: 0.87)) // 진한 파랑
                            .background(Color(red: 0.9, green: 0.95, blue: 1.0)) // 연파랑 배경
                            .cornerRadius(8)
                    }
                    
                    
                    Button(action: {
                        onReject()
                        print("그룹 초대를 거절하셨습니다")
                    }) {
                        Text("거절")
                            .font(Font.custom("Pretendard", size: 14).weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundColor(Color(red: 1, green: 0.36, blue: 0.35))
                            .background(Color(red: 1, green: 0.92, blue: 0.92))

                            .cornerRadius(8)
                    }
                    
                }//groupInvite
         
            } //HStack
            .padding(.horizontal)
        }
        
        var mainText: String {
            switch item {
            case .groupInvite(let sender, _):
                return "\(sender)님이 보낸 그룹 초대"
            case .memberNoVerification(let sender, _):
                return "\(sender)님이 오늘 인증하지 않았어요"
            }
        }

        var subtitleText: String? {
           switch item {
           case .groupInvite(_, let groupName),
                .memberNoVerification(_, let groupName):
               return groupName
           }
       }
    }


#Preview {
    @State var selectedImage: UIImage? = nil

    let mockItem: NotificationType = .groupInvite(
        sender: "이주원",
        groupName: "롱커톤 모여라"
    )

    return NotificationRow(
        item: mockItem,
        selectedImage: $selectedImage,
        onReject: {
            print("프리뷰에서 거절 버튼 눌림")
        }
    )
}
