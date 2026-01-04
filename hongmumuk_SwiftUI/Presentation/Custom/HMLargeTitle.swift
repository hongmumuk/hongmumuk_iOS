import SwiftUI

struct HMLargeTitle: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .setFont()
                .setPadding()
            
            Spacer()
        }
    }
}

private extension View {
    func setFont() -> some View {
        fontStyle(Fonts.title2Bold)
    }
    
    func setPadding() -> some View {
        padding(.top, 32)
            .padding(.bottom, 12)
            .padding(.horizontal, 24)
    }
}
