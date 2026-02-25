import SwiftUI

@Observable
class DetailViewModel {
    var selectedId: String
    private var detail: DetailModel?
    
    // UI 프로퍼티
    var isLoading: Bool = true
    var images: [String] = []
    var placeName: String = ""
    var title: String = ""
    var subtitle: String = ""
    var category: Category?
    var walkTime: Int?
    var tags: [String] = []
    var description: String = ""
    var address: String = ""
    var menus: [DetailMenu] = []
    var viewCount: Int = 0
    
    init(selectedId: String) {
        self.selectedId = selectedId
    }
    
    func onAppear() {
        // 데이터가 없으면 로드
        guard detail == nil else {
            return
        }
        
        Task {
            isLoading = true
            do {
                let detail = try await SupabaseService.shared.getDetail(for: selectedId)
                self.detail = detail
                convertToUIModel(detail)
            } catch {
                print("❌ detail error", error)
            }
            isLoading = false
        }
    }
    
    private func convertToUIModel(_ detail: DetailModel) {
        placeName = detail.placeName ?? ""
        title = detail.title ?? ""
        subtitle = detail.subtitle ?? ""
        description = detail.description ?? ""
        address = detail.address ?? ""
        walkTime = detail.walkTime
        viewCount = detail.viewCount ?? 0
        
        // category 변환 - displayName으로 찾기
        if let categoryLabel = detail.category {
            category = Category.allCases.first { $0.displayName == categoryLabel }
        }
        
        // photos 배열을 정렬해서 images로 변환
        if let photos = detail.photos, !photos.isEmpty {
            images = photos
                .sorted { $0.sortOrder < $1.sortOrder }
                .map { $0.url }
        }
        
        // tags 복사
        tags = detail.tags ?? []
        
        // menus 복사
        menus = detail.menus ?? []
    }
}
