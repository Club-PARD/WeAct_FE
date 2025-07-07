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
            // ✅ 배경 이미지 → SafeArea 무시 (전체 화면 덮기)
            Image("result_Back")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                // ✅ SafeArea 안의 상단 영역
                VStack(spacing: 0) {
                    Spacer().frame(height: 32)
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                        
                        Spacer(minLength: 30)  // ✅ 여기서 최소 간격 조절 가능
                        
                        Text("자랑하기")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.top)
                        
                        Spacer()  // 나머지 공간 다 차지 → 오른쪽 정렬 맞춤
                    }
                    .padding(.top)
                    .padding(.horizontal)
                }

                Spacer().frame(height: 94)
                
                
                // 캡처 대상
                CaptureArea {
                    VStack(spacing: 16) {
                        // 일러스트
                        Image("result_rank1").resizable().frame(width: 276, height:  228)
                        
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
                        
                        Image("logo").resizable().frame(width: 90, height: 30)
                    }
                    .padding()
                    .frame(width: 280)
                    .background(Color.white)
                    .cornerRadius(24)
                }
                .frame(height: 380) // 캡처 대상 크기
                Spacer()
                // 저장 버튼
                Button(action: {
                    saveCaptureToPhotos()
                }) {
                    Text("이미지 저장")
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color(.blue))
                        .clipShape(Capsule())
                }
                
                Spacer()
            }

            // ✅ 저장되었습니다 토스트
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Image("RedCheckmark")
                        Spacer().frame(width: 10)
                        Text("이미지가 저장되었어요!")
                            .foregroundColor(.white)
                            .font(.body)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.darkGray))
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                    .transition(.opacity)
                }
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



