//
//  CertificationCard.swift
//  WeAct
//
//  Created by 현승훈 on 7/8/25.
//

import SwiftUI

struct CertificationCard: View {
    let userName: String
        init(userName: String = "이주원") {
            self.userName = userName
        }
    var body: some View {
        ZStack {
            // 맨뒤 카드 배경
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "FFFFFF"))
                .frame(width: 140, height: 186)
            
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.clear)  // 우선 투명으로 채움
                .frame(width: 132, height: 174)
                .overlay(
                    Image("image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 132, height: 174)
                        .clipShape(RoundedRectangle(cornerRadius: 7))  // 모서리 둥글게 자름
                )
            VStack {
                HStack {
                    Text(userName)
                        .font(.custom("Pretendard-Bold", size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(Color(hex: "FFFFFF"))
                        .cornerRadius(6, corners: [.bottomRight])
                    Spacer()
                }
                Spacer()
                Image("heart").padding(.trailing, 90)
                Spacer().frame(height:10)
            }
            .frame(width: 132, height: 174)
            .padding(.bottom, 2)
        }
    }
        
}

#Preview {
    CertificationCard()
}
