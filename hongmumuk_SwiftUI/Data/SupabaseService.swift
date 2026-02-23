import Supabase
import SwiftUI

final class SupabaseService {
    static let shared = SupabaseService()
    private let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: Constant.supabaseUrlString)!,
            supabaseKey: Constant.supabaseKey
        )
    }
    
    func getScreen(for type: Screen) async throws -> ScreenModel {
        let response: ScreenModel = try await SupabaseService.shared.client
            .rpc("get_screen", params: ["p_screen_key": type.rawValue])
            .execute()
            .value
        
        return response
    }
    
    func getScreenJson(for type: Screen) async throws {
        let response = try await SupabaseService.shared.client
            .rpc("get_screen", params: ["p_screen_key": type.rawValue])
            .execute()
        
        let jsonString = String(data: response.data, encoding: .utf8)
        print("📥 raw JSON:\n\(jsonString)")
    }
    
    func getDetail(for id: String) async throws -> DetailModel {
        let response: DetailModel = try await SupabaseService.shared.client
            .rpc("get_place_detail", params: ["p_place_id": id])
            .execute()
            .value
        
        return response
    }
    
    func postViewCnt(for id: String) async throws {
        let response = try await SupabaseService.shared.client
            .rpc("increment_view_count", params: ["p_content_id": id])
            .execute()

        print("status:", response.status)
    }
}
