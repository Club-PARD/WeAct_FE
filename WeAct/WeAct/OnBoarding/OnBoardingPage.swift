import SwiftUI

struct OnBoardingPage: View {
    @State private var currentIndex = 0
    @Binding var isFirstLaunch: Bool

    let onboardingData: [OnboardingContent] = [
        OnboardingContent(title: "그룹생성하기", sub: "함께 습관을 달성할 친구를 초대하고,\n1등보상도 정해보세요!", imageText: "온보딩 설명 관련\n일러스트 1"),
        OnboardingContent(title: "습관 인증하기", sub: "사진과 메모로 오늘의 습관을 기록해주세요!\n인증한 내용은 그룹 보드에서 볼 수 있어요", imageText: "온보딩 설명 관련\n일러스트 2"),
        OnboardingContent(title: "랭킹 공개", sub: "습관 인증률에 따라 랭킹이 정해져요! \n인증 기간 동안 중간/최종 랭킹이 발표 돼요.", imageText: "온보딩 설명 관련\n일러스트 3")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 32)

            TabView(selection: $currentIndex) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    VStack(spacing: 24) {
                        Text(onboardingData[index].title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Text(onboardingData[index].sub)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 240, height: 240)
                            .overlay(
                                Text("온보딩 설명 관련\n일러스트")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                            )
                            .cornerRadius(16)

                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 480)

            // 🔽 인디케이터 + 버튼 묶기
            VStack(spacing: 0) {
                // 🔵 페이지 인디케이터
                HStack(spacing: 8) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                //.padding(.top, 16)
                .padding(.bottom, 92)

                // 버튼 유무와 관계없이 공간 확보
                if currentIndex == onboardingData.count - 1 {
                    Button(action: {
                        isFirstLaunch = false
                    }) {
                        Text("시작하기")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#FF632F"))
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 36)
                } else {
                    // 버튼이 없는 경우에도 동일한 높이 확보 (빈 공간으로 대체)
                    Color.clear
                        .frame(height: 52 + 36) // 버튼 높이 + padding.bottom과 동일하게
                }
            }

        }
        .background(Color(hex: "#F7F7F7"))
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingContent {
    let title: String
    let sub: String
    let imageText: String
}
