import SwiftUI

struct Splash: View {
    var body: some View {
        ZStack {
            Color(hex: "FF632F")
                .edgesIgnoringSafeArea(.all)
            Image(systemName: "globe")
                .font(.system(size: 100))
                .foregroundColor(.white)
        }
    }
}
