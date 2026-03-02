import SwiftUI

struct HMNavigationBar: View {
    var body: some View {
        HStack {
            Image("topLogo")
                .padding(.leading, 24)
                .padding(.vertical, 14)
            
            Spacer()
        }
        .frame(height: 60)
    }
}
