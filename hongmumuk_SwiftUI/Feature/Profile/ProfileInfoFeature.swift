//
//  ProfileInfoFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import ComposableArchitecture
import SwiftUI

struct ProfileInfoFeature: Reducer {
    struct State: Equatable {
        var pickerSelection = 0
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case pickerSelectionChanged(Int)
    }
    
    @Dependency(\.keychainClient) var keychainClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .onDismiss:
                return .none
                
            case let .pickerSelectionChanged(index):
                state.pickerSelection = index
                return .none
            }
        }
    }
}
