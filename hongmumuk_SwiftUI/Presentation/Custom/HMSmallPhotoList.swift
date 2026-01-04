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
    }
}

let tagSmallCards: [HMTagSmallPhoto] = [
    .init(
        title: "요즘 뜨는 홍대 커피바, 틴클",
        tags: ["상수역", "에스프레소바"],
        category: .asian,
        distance: 10
    ),
    .init(
        title: "장소만 옮겼어요, 하카타분코",
        tags: ["사장님은", "같아요"],
        category: .japanese,
        distance: 10
    ),
    .init(
        title: "리뉴얼해서 돌아온, 별버거",
        tags: ["10년째", "단골"],
        category: .asian,
        distance: 10
    )
]

let categorySmallCards: [HMCategorySmallPhoto] = [
    .init(
        title: "집밥김치찌개",
        tag: "베스트",
        category: .korean,
        distance: 10
    ),
    .init(
        title: "하카타 분코",
        tag: "에디터 픽",
        category: .japanese,
        distance: 10
    ),
    .init(
        title: "별버거",
        tag: "새로운",
        category: .asian,
        distance: 10
    )
]

let cafeBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "평일/주말 언제든 10% 할인",
        subTitle: "HIDE AND SEEK 쌈지길점",
        tag: "방탈출 카페",
        address: "서울 마포구 잔다리로 143"
    ),
    .init(
        title: "전 메뉴 10% 할인 (5만원 이하까지)",
        subTitle: "꾸울과자점",
        tag: "베이커리",
        address: "서울 마포구 상수동 88-14"
    )
]

let restaurantBenefitCards: [HMBeniftSmallPhoto] = [
    .init(
        title: "전체 금액에서 10% 할인",
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
