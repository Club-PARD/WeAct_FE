import SwiftUI

struct WelcomePage: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea() // ✅ SafeArea까지 꽉 채우는 배경
            
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

                Image("StartingPage")

                Spacer()

                // 시작하기 버튼
                Button(action: {
                    isLoggedIn = true
                }) {
                    Text("시작하기")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FF632F"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}


#Preview {
    WelcomePage()
}
