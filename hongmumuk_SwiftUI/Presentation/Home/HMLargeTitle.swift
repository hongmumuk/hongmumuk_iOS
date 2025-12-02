import SwiftUI

struct HMLargeTitle: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontStyle(Fonts.title2Bold)
                .padding(.top, 32)
                .padding(.bottom, 12)
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(.red)
    }
}
