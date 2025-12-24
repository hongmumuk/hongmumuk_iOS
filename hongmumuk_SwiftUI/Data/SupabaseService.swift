import Supabase
import SwiftUI

final class SupabaseService {
    static let shared = SupabaseService()
    let client: SupabaseClient
        
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: Constant.supabaseUrlString)!,
            supabaseKey: Constant.supabaseKey
        )
    }
    
    func getHome() async throws -> HomeModel {
        let response: HomeModel = try await SupabaseService.shared.client
            .rpc("get_screen", params: ["p_screen_key": "home"])
            .execute()
            .value
        
        return response
    }
    
    func getDetail(for id: String) async throws -> DetailModel {
        let response: DetailModel = try await SupabaseService.shared.client
            .rpc("get_content_detail", params: ["p_content_id": id])
            .execute()
            .value
        
        return response
    }
}
