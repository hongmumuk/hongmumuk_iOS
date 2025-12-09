import SwiftUI

struct HMSmallPhotoList: View {
    let items: [any HMSmallPhoto]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items, id: \.id) { card in
                HMSmallPhotoCard(card: card)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
        }
        .background(.green)
    }
}

let tagSmallCards: [HMTagSmallPhoto] = [
    .init(
        title: "연남동 브런치",
        tags: ["브런치", "감성", "사진맛집"],
        category: .asian,
        distance: 3
    ),
    .init(
        title: "불타는 제육",
        tags: ["제육", "매콤", "밥도둑"],
        category: .chinese,
        distance: 5
    ),
    .init(
        title: "집밥 김치찌개",
        tags: ["김치찌개", "한식", "혼밥"],
        category: .korean,
        distance: 2
    )
]

let categorySmallCards: [HMCategorySmallPhoto] = [
    .init(
        title: "연남 감성 카페",
        tag: "베스트",
        category: .asian,
        distance: 3
    ),
    .init(
        title: "홍대 짜장면 맛집",
        tag: "에디터픽",
        category: .chinese,
        distance: 5
    ),
    .init(
        title: "감성 브런치 식당",
        tag: "브런치",
        category: .asian,
        distance: 6
    )
]

let cafeBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "입장료 10% 즉시 할인",
        subTitle: "HIDE AND SEEK 쌈지길점",
        tag: "방탈출",
        address: "서울 마포구 잔다리로 143"
    ),
    .init(
        title: "전 메뉴 10% 할인 (최대 5만원)",
        subTitle: "꾸울과자점",
        tag: "베이커리",
        address: "서울 마포구 상수동 88-14"
    )
]

let restaurantBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "결제 금액 10% 할인",
        subTitle: "고토히라우동",
        tag: "일식",
        address: "서울 마포구 서교동 327-20"
    ),
    .init(
        title: "계란찜/라면/돼지껍데기 중 하나 제공",
        subTitle: "오일내",
        tag: "한식",
        address: "서울 마포구 서교동 364-18"
    )
]

let lifeCultureBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "커트 20% 할인/펌, 염색 30% 할인",
        subTitle: "헤어더봄 홍대점",
        tag: "미용실",
        address: "서울 마포구 홍익로 4 아나빌딩 2층"
    ),
    .init(
        title: "탈색, 염색 30% 할인",
        subTitle: "베이바이허슬기",
        tag: "미용실",
        address: "서울 마포구 어울마당로 59 1층"
    )
]
