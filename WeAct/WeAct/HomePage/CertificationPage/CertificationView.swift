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

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("오늘은 어떻게 인증할까요?")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 10) {
                Button(action: {
                    selectedOption = "인증할래요"
                }) {
                    Text("인증할래요")
                        .foregroundColor(selectedOption == "인증할래요" ? .white : .gray)
                        .padding()
                        .background(selectedOption == "인증할래요" ? Color(hex: "#464646") : Color(hex: "#E7E7E7"))
                        .cornerRadius(8)
                }

                Button(action: {
                    selectedOption = "해명할래요"
                }) {
                    Text("해명할래요")
                        .foregroundColor(selectedOption == "해명할래요" ? .white : .gray)
                        .padding()
                        .background(selectedOption == "해명할래요" ? Color(hex: "#464646") : Color(hex: "#E7E7E7"))
                        .cornerRadius(8)
                }
            }

            VStack(alignment: .leading) {
                Text(selectedOption == "인증할래요" ? "한 마디를 작성해주세요" : "친구에게 해명 한마디를 전해주세요")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .frame(height: 54)

                    HStack {
                        LimitedTextField(text: $message, placeholder: "오늘의인증합니다아아", characterLimit: 15).frame(height: 20) // 👈 텍스트 높이에 맞춰 조절
                            .padding(.vertical, 10)
                        Spacer()
                        Text("\(message.count)/15")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.trailing, 8)
                    }
                    .padding(.horizontal, 12)
                }
            }


            if selectedOption == "인증할래요" {
                VStack(alignment: .leading) {
                    Text("인증 사진을 등록해주세요")
                        .font(.subheadline)
                        .foregroundColor(.gray)

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
                                .fill(Color(.systemGray6))
                                .frame(width: 181, height: 229)
                                .overlay(
                                    Image(systemName: "camera")
                                        .font(.system(size: 24))
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                }
            }


            Spacer()

            Button(action: {
                // 전송 로직
            }) {
                Text("전송하기")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.darkGray))
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $image)
        }
    }
       // .background(Color(hex:"#FF632F"))

}

