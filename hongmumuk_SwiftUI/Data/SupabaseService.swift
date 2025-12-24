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
}
