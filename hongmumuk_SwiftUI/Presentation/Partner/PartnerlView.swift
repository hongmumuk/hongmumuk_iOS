import SwiftUI

struct PartnerlView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HMFilter(isImage: false)
                HMLargeTitle(title: "카페")
//                    HMSmallPhotoList(items: cafeBenefitCards)
                HMLargeTitle(title: "음식점")
//                    HMSmallPhotoList(items: restaurantBenefitCards)
                HMLargeTitle(title: "생활/문화")
//                    HMSmallPhotoList(items: lifeCultureBenefitCards)
                Spacer()
            }
        }
        .padding(.top)
    }
}
