import SwiftUI

struct Splash: View {
    var body: some View {
        ZStack {
            Color(hex: "FF4B2F")
                .edgesIgnoringSafeArea(.all)
            Image("splashLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
        }
    }
}


#Preview {
    Splash()
}
