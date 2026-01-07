import SwiftUI

@Observable
class DetailViewModel {
    var selectedId: String
    var detail: DetailModel?
    
    init(selectedId: String) {
        self.selectedId = selectedId
    }
    
    func onAppear() {
        Task {
            do {
                let detail = try await SupabaseService.shared.getDetail(for: selectedId)
                self.detail = detail
                print("detail", detail)
            } catch {
                print("detail error", error)
            }
        }
    }
}
