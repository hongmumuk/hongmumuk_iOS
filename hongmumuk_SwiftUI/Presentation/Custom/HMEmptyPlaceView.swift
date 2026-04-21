import SwiftUI

struct EmptyPlaceView: View {
    private let text = "아직 장소가 추가되지 않았어요.\n조금만 기다려 주세요!"
    
    var body: some View {
        VStack(spacing: 16) {
            Image("smileyWink")
                .resizable()
                .frame(width: 80, height: 80)
            
            Text(text)
                .fontStyle(Fonts.heading3Regular)
                .foregroundColor(Color(hex: "#8F92A3"))
                .multilineTextAlignment(.center)
        }
        .frame(width: 354, height: 264)
    }
}
