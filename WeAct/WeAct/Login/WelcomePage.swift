import SwiftUI

struct WelcomePage: View {
    @State private var navigateToOnboarding = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 상단 텍스트
            VStack(spacing: 8) {
                Text("환영해요!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("대충 축하한다는 내용의 글")
                    .font(.body)
                    .foregroundColor(.gray)
            }

            // 일러스트 SVG 대체
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 120, height: 120)
                .overlay(
                    Text("일러스트 svg")
                        .foregroundColor(.gray)
                        .font(.caption)
                )
                .cornerRadius(16)
                .padding(.top, 20)

            Spacer()

            // 시작하기 버튼
            Button(action: {
                navigateToOnboarding = true
            }) {
                Text("시작하기")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .fullScreenCover(isPresented: $navigateToOnboarding) {
            OnBoardingPage()
        }
    }
}
