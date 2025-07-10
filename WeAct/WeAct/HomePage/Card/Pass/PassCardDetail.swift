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
    
    let userName: String = "이단진"
    let message: String = "오늘은 운동을 쉬었습니다"
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                //.frame(width: 280, height: 452)
                .overlay(
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            Image("rest")
                                .resizable()
                                .scaledToFill()
                                
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding(.top,6)
                            

                            Button(action: {
                                withAnimation {
                                    isPresented = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(20)
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 20)
                            .padding(.trailing, 20)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10) {
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
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
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

#Preview {
    PassCardDetail(isFlipped: .constant(false), isPresented: .constant(false))
}
