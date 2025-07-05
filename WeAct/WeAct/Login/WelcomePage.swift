import SwiftUI

struct WelcomePage: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 상단 텍스트
            VStack(spacing: 8) {
                Text("환영해요!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("이제부터 WeAct와 함께 습관 인증 시작해요.")
                    .font(.body)
                    .foregroundColor(.gray)
            }

            // 일러스트 SVG 대체
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    Image("StartingPage")
                )
                .cornerRadius(16)
                .padding(.top, 20)

            Spacer()

            // 시작하기 버튼
            Button(action: {
                isLoggedIn = true
            }) {
                Text("시작하기")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.init(hex: "#FF632F"))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
//        .fullScreenCover(isPresented: $navigateToOnboarding) {
//            OnBoardingPage()
//        }
    }
}


#Preview {
    WelcomePage()
}
