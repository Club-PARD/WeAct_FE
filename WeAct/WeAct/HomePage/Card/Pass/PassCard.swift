//
//  PassCard.swift
//  WeAct
//
//  Created by 현승훈 on 7/8/25.
//
import SwiftUI

struct PassCard: View {
    let userName: String
        init(userName: String = "이단진") {
            self.userName = userName
        }
    var body: some View {
        ZStack {
            
            
            // 맨뒤 카드 배경
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "313030"))
                .frame(width: 140, height: 186)
            
            // 위에 얹는 카드
            RoundedRectangle(cornerRadius: 7)
                .fill(Color(hex: "3D3D3D"))
                .frame(width: 132, height: 174)
//                .overlay(
//                    VStack {
//                        Spacer()
//                    }
//                )
//                

            
            
            VStack {
                HStack {
                    Text(userName)
                        .font(.custom("Pretendard-Bold", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(Color(hex: "313030"))
                        .cornerRadius(6, corners: [.bottomRight])  // 하단 오른쪽 모서리만 둥글게!
                    
                    Spacer()
                }
                .padding(.leading, 0)
                .padding(.top, -10)
                
                Image("resticon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 86, height: 86)
                Spacer().frame(height: 13)
                
                Text("오늘은 쉴게요")
                    .font(.custom("Pretendard-Bold", size: 18))
                    .foregroundColor(.white)
                    .padding(.bottom,12)
            }
            .frame(width: 132, height: 174)
            
            .padding(.bottom, 2)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


#Preview {
    PassCard()
}
