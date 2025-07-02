import SwiftUI

struct OnBoardingPage: View {
    @State private var currentIndex = 0
    @Binding var isFirstLaunch: Bool
    
    // 온보딩 콘텐츠 (3개 페이지)
    let onboardingData: [OnboardingContent] = [
        OnboardingContent(title: "온보딩 설명(1)", imageText: "온보딩 설명 관련\n일러스트 1"),
        OnboardingContent(title: "온보딩 설명(2)", imageText: "온보딩 설명 관련\n일러스트 2"),
        OnboardingContent(title: "온보딩 설명(3)", imageText: "온보딩 설명 관련\n일러스트 3")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 제목
            Text(onboardingData[currentIndex].title)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            // 이미지 대체 (일러스트 SVG 대신 텍스트 사용)
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 200, height: 200)
                .overlay(
                    Text(onboardingData[currentIndex].imageText)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.body)
                )
                .cornerRadius(16)

            // 페이지 인디케이터
            HStack(spacing: 8) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.gray : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }

            Spacer()

            // 버튼
            Button(action: {
                if currentIndex < onboardingData.count - 1 {
                    currentIndex += 1
                } else {
                    print("온보딩 완료 → 홈이나 로그인으로 이동") // 나중에 네비게이션 연결 가능
                }
            }) {
                Text(currentIndex == onboardingData.count - 1 ? "시작하기" : "다음")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .navigationBarBackButtonHidden(true)
    }
}

// 온보딩 콘텐츠 구조체
struct OnboardingContent {
    let title: String
    let imageText: String
}

