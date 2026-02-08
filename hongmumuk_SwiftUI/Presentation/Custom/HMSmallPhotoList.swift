import SwiftUI

struct HMSmallPhotoList: View {
    let cards: [any HMSmallPhoto]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(cards, id: \.id) { card in
                HMSmallPhotoCard(card: card)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
        }
    }
}

let cafeBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "평일/주말 언제든 10% 할인",
        subTitle: "HIDE AND SEEK 쌈지길점",
        tag: "방탈출 카페",
        address: "서울 마포구 잔다리로 143",
        imageUrl: ""
    ),
    .init(
        title: "전 메뉴 10% 할인 (5만원 이하까지)",
        subTitle: "꾸울과자점",
        tag: "베이커리",
        address: "서울 마포구 상수동 88-14",
        imageUrl: ""
    )
]

let restaurantBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "전체 금액에서 10% 할인",
        subTitle: "고토히라우동",
        tag: "일식",
        address: "서울 마포구 서교동 327-20",
        imageUrl: ""
    ),
    .init(
        title: "계란찜/라면/돼지껍데기 중 하나 제공",
        subTitle: "오일내",
        tag: "한식",
        address: "서울 마포구 서교동 364-18",
        imageUrl: ""
    )
]

let lifeCultureBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "커트 20% 할인/펌, 염색 30% 할인",
        subTitle: "헤어더봄 홍대점",
        tag: "미용실",
        address: "서울 마포구 홍익로 4 아나빌딩 2층",
        imageUrl: ""
    ),
    .init(
        title: "탈색, 염색 30% 할인",
        subTitle: "베이바이허슬기",
        tag: "미용실",
        address: "서울 마포구 어울마당로 59 1층",
        imageUrl: ""
    )
]
