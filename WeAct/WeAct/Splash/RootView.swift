import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @State private var showSplash = true
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        ZStack {
            if showSplash {
                Splash()
            } else {
                if isLoggedIn {
                    MainView(userViewModel: userViewModel)
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
    }
}

#Preview {
    RootView()
}
