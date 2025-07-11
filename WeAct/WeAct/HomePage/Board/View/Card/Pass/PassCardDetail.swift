//
//  PassCardDetail.swift
//  WeAct
//
//  Created by 현승훈 on 7/9/25.
//

import SwiftUI

struct PassCardDetail: View {
    @Binding var isFlipped: Bool
    @Binding var isPresented: Bool
    
    let userName: String = "주현아"
    let message: String = "Sorry..."
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 280, height: 452)
                .overlay(
                    VStack(spacing: 0) {
                        Spacer().frame(height: 5)
                        ZStack(alignment: .topTrailing) {
                            Image("rest")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 340, height: 360)
                                .mask(
                                    RoundedCorners(radius: 20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                )
                                
                            Button(action: {
                                withAnimation {
                                    isPresented = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(.top, 15)
                                    .padding(.trailing, 25)
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(.top, 0)
                            .padding(.trailing, 20)
                        }
                        
                        Spacer().frame(height: 14)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Image("BasicProfile")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                Text(userName)
                                    .font(.custom("Pretendard-Bold", size: 18))
                                Spacer()
                            }
                            
                            Text(message)
                                .font(.custom("Pretendard-Medium", size: 14))
                                .foregroundColor(Color(hex: "464646"))
                        }
                        //.padding(.top, 44)
                        .padding(.leading, 16)
                        .padding(.bottom, 24 )
                    }
                )

            
            Spacer().frame(height: 53)
            
            Button(action: {
                withAnimation {
                    isFlipped = true  // ✅ 댓글 보기로 뒤집기
                }
            }) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("댓글 달기")
                }
            }
            .foregroundColor(.white)
            .frame(width: 118, height: 48)
            .background(Color(hex: "FF4B2F"))
            .cornerRadius(24)
        }
    }
}

// ✅ 모서리 방향 설정 가능하게 커스텀
struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
