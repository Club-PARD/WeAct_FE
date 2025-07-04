//
//  CelebratePage.swift
//  WeAct
//
//  Created by 현승훈 on 7/1/25.
//
import SwiftUI
import Photos

struct CelebratePage: View {
    @Environment(\.dismiss) var dismiss
    @State private var showToast = false
    @State private var imageToSave: UIImage?
    @Binding var path: NavigationPath
    var body: some View {
        ZStack {
            Color(red: 239/255, green: 243/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                // 상단 커스텀 뒤로 버튼
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                            Text("뒤로")
                                .foregroundColor(.black)
                                .font(.body)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // 캡처 대상
                CaptureArea {
                    VStack(spacing: 16) {
                        Text("습관 랭킹 1등")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 16)

                        // 일러스트
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 100, height: 100)
                            .overlay(Text("일러스트 svg").font(.caption).foregroundColor(.gray))

                        Text("이주원")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Divider()

                        VStack(spacing: 8) {
                            HStack {
                                LabelBox(title: "방 명")
                                Spacer()
                                Text("롱커톤 모여라")
                                    .font(.caption)
                            }
                            HStack {
                                LabelBox(title: "기 간")
                                Spacer()
                                Text("2025.6.3 - 6.9")
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 0)

                        Text("앱 로고")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 16)
                    }
                    .padding()
                    .frame(width: 280)
                    .background(Color.white)
                    .cornerRadius(24)
                }
                .frame(height: 380) // 캡처 대상 크기

                // 저장 버튼
                Button(action: {
                    path.append("celebrate")
                    saveCaptureToPhotos()
                }) {
                    Text("이미지 저장하기")
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color(.darkGray))
                        .clipShape(Capsule())
                }

                Spacer()
            }

            // ✅ 저장되었습니다 토스트
            if showToast {
                VStack {
                    Spacer()
                    Text("저장되었습니다")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - 이미지 저장 함수
    func saveCaptureToPhotos() {
        // capture 대상 뷰를 이미지로 변환
        let renderer = ImageRenderer(content: CaptureArea {
            CelebrateCardContent()
        })
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }
    }
}

// MARK: - 캡처 대상 콘텐츠 따로 분리
struct CelebrateCardContent: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("습관 랭킹 1등")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 16)

            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 100, height: 100)
                .overlay(Text("일러스트 svg").font(.caption).foregroundColor(.gray))

            Text("이주원")
                .font(.title2)
                .fontWeight(.semibold)

            Divider()

            VStack(spacing: 8) {
                HStack {
                    LabelBox(title: "방 명")
                    Spacer()
                    Text("롱커톤 모여라")
                        .font(.caption)
                }
                HStack {
                    LabelBox(title: "기 간")
                    Spacer()
                    Text("2025.6.3 - 6.9")
                        .font(.caption)
                }
            }
            .padding(.horizontal)

            Spacer(minLength: 0)

            Text("앱 로고")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 16)
        }
        .padding()
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(24)
    }
}

// MARK: - 캡처용 컨테이너 뷰
struct CaptureArea<Content: View>: View {
    let content: () -> Content
    var body: some View {
        content()
    }
}

// MARK: - 라벨 박스
struct LabelBox: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption)
            .foregroundColor(.gray)
            .padding(4)
            .background(Color(.systemGray6))
            .cornerRadius(6)
    }
}
