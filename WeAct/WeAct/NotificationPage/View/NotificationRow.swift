

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
                        Image(systemName: "checkmark")
                    }
                    .style()
                    
                    Button(action: {
                        onReject()
                        print("그룹 초대를 거절하셨습니다")
                    }) {
                        Image(systemName: "xmark")
                    }
                    .style()
                }//groupInvite
                else if case let .verificationRejected(_, _, image) = item {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 43, height: 43)
                        .background(Color(red: 0.9, green: 0.93, blue: 0.96))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
//
                }//verificationRejected
            } //HStack
            .padding(.horizontal)
        }
        
        var mainText: String {
            switch item {
            case .groupInvite(let sender, _):
                return "\(sender)님이 보낸 그룹 초대"
            case .verificationRejected(let sender, _, _):
                return "\(sender)님의 인증이 거절되었어요"
            case .memberNoVerification(let sender, _):
                return "\(sender)님이 오늘 인증하지 않았어요"
            }
        }

        var subtitleText: String? {
           switch item {
           case .groupInvite(_, let groupName),
                .memberNoVerification(_, let groupName):
               return groupName
           case .verificationRejected(_, let reason, _):
               return "이유  |  \(reason)"
           }
       }
    }


private extension View {
    func style() -> some View {
        self
            .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
            .frame(width: 43, height: 43)
            .background(Color(red: 0.9, green: 0.93, blue: 0.96))
            .cornerRadius(50)
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
