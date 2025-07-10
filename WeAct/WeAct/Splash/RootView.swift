import SwiftUI

struct RootView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var showSplash = true
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack {
            if showSplash {
                            Splash()
                        } else {
                            if isLoggedIn {
                                MainView()
                                    .environmentObject(userViewModel)
                            } else {
                                if isFirstLaunch {
                                    OnBoardingPage(isFirstLaunch: $isFirstLaunch)
                                } else {
                                    ContentView()
                                }
                            }
                        }
                    }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
        .environmentObject(userViewModel)
    }
}


#Preview {
    RootView()
        .environmentObject(UserViewModel())
}
