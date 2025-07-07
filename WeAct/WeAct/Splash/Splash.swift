import SwiftUI

struct Splash: View {
    var body: some View {
        ZStack {
            Color(hex: "FF4B2F")
                .edgesIgnoringSafeArea(.all)
            
            Image("splash")
                .resizable()
                .frame(width:180, height: 100)
        }
    }
}
