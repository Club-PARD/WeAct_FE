//
//  CustonModalView.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//


import SwiftUI

struct CustomModalView: View {
    var title: String
    var message: String
    var firstButtonTitle: String
    var secondButtonTitle: String
    var firstButtonAction: () -> Void
    var secondButtonAction: () -> Void
    
    var body: some View {
        VStack() {
            // 제목
            Text(title)
                .font(
                    Font.custom("Pretendard", size: 22)
                        .weight(.medium)
                )
                .background(Color.white)
                .padding(.top, 26)
                .padding(.bottom,8)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // 본문
            Text(message)
                .font(
                Font.custom("Pretendard", size: 14)
                .weight(.medium)
                )
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.53))
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)

            // 버튼들
            HStack(spacing: 12) {
                Button(action: firstButtonAction) {
                    Text(firstButtonTitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.53))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 16)
                        .frame(width: 125, height: 46, alignment: .center)
                        .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                        .cornerRadius(8)
                }

                Button(action: secondButtonAction) {
                    Text(secondButtonTitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 16)
                        .frame(width: 125, height: 46, alignment: .center)
                        .background(Color(red: 0.27, green: 0.27, blue: 0.27))
                        .cornerRadius(8)
                }
            }
            .padding(.bottom)
        }
        .frame(width: 290, height: 187)
        .background(Color.white)
        .cornerRadius(14)
    }
}

#Preview {
    CustomModalView(
        title: "로그아웃하시겠습니까?",
        message: "계정에서 로그아웃합니다.\n언제든 다시 로그인할 수 있어요.",
        firstButtonTitle: "취소",
        secondButtonTitle: "로그아웃",
        firstButtonAction: {
            print("취소 버튼 클릭")
        },
        secondButtonAction: {
            print("로그아웃 버튼 클릭")
        }
    )
    .previewLayout(.sizeThatFits)
}
