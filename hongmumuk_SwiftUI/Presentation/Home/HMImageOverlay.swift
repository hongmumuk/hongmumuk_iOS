import SwiftUI

struct HMImageOverlay: View {
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: Color.black.opacity(0.1), location: 0.0),
                .init(color: Color.black.opacity(0.6), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
