//
//  CertificationView.swift
//  WeAct
//
//  Created by 현승훈 on 7/1/25.
//

import SwiftUI

struct CertificationView: View {
    @State private var selectedOption = "인증할래요"
    @State private var message = ""
    @State private var image: UIImage? = nil
    @State private var showingImagePicker = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(hex: "F7F7F7")
                        .ignoresSafeArea()
            Text("습관인증하기")
                .font(
                    Font.custom("Pretendard", size: 18)
                        .weight(.medium)
                )
                .foregroundColor(.black)

            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 15)

        VStack(alignment: .leading) {
            Text("오늘은 어떻게 인증할까요?")
                .font(.custom("Pretendard-Medium", size: 16))
                .foregroundColor(Color(hex: "858588"))
                .padding(.top, 43)
            
            HStack(spacing: 10) {
                Button(action: {
                    selectedOption = "인증할래요"
                }) {
                    Text("인증할래요")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(selectedOption == "인증할래요" ? .white : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedOption == "인증할래요" ? Color(hex: "464646") : Color(hex: "E7E7E7"))
                        .cornerRadius(8)
                        .font(
                            Font.custom("Pretendard", size: 16)
                                .weight(.medium)
                        )
                }

                Button(action: {
                    selectedOption = "해명할래요"
                }) {
                    Text("해명할래요")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(selectedOption == "해명할래요" ? .white : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedOption == "해명할래요" ? Color(hex: "#464646") : Color(hex: "#E7E7E7"))
                        .cornerRadius(8)
                        .font(
                            Font.custom("Pretendard", size: 16)
                                .weight(.medium)
                        )
                }
            }
            .padding(.vertical, 12)

            VStack(alignment: .leading) {
                Text(selectedOption == "인증할래요" ? "한 마디를 작성해주세요" : "친구에게 해명 한마디를 전해주세요")
                    .font(.custom("Pretendard-Medium", size: 16))
                    .foregroundColor(Color(hex: "858588"))

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                        .frame(height: 54)

                    HStack {
                        LimitedTextField(text: $message, placeholder: "오늘의인증합니다아아", characterLimit: 15)
                            .frame(height: 20)
                            .padding(.vertical, 22)
                        
                        
                        Spacer()
                        (
                            Text("\(message.count)")
                                .foregroundColor(Color(hex: "FF4B2F"))
                            +
                            Text("/15")
                                .foregroundColor(.gray)
                        )
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.medium)
                        )
                        .padding(.trailing, 22)
                    }
                    .padding(.horizontal, 12)
                }
            }

            VStack(alignment: .leading, spacing: 17) {
                Text("인증 사진을 등록해주세요")
                    .font(.custom("Pretendard-Medium", size: 16))
                    .foregroundColor(Color(hex: "FFFFFFF"))

                HStack {
                    Spacer()
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 181, height: 229)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .clipped()
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                .foregroundColor(.gray)
                                .frame(width: 181, height: 229)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 30, weight: .regular))
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $image)
                    }
                    Spacer()
                }
            }
            .opacity(selectedOption == "인증할래요" ? 1 : 0)
            .allowsHitTesting(selectedOption == "인증할래요")

            Spacer()

            Button(action: {
                // 전송 로직
            }) {
                Text("게시하기")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "FF4B2F"))
                    .cornerRadius(10)
                    .font(
                        Font.custom("Pretendard", size: 18)
                            .weight(.medium)
                    )
            }
        }
        .padding(.bottom, 18)
        .padding(.horizontal, 18)
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    CertificationView()
//}
