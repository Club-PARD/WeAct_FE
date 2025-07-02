import SwiftUI

struct Splash: View {
    var body: some View {
        ZStack {
            Color(hex: "FF632F")
                            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "globe")
                    .font(.system(size: 100))
                    
            }
        }
    }
}
