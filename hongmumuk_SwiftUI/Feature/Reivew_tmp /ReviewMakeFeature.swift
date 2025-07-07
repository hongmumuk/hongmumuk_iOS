//
//  ReviewMakeFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import ComposableArchitecture

struct ReviewMakeFeature: Reducer {
    struct State: Equatable {
        var starRate: Double = 0
        var photoCount: Int = 0
    }
    
    enum Action: Equatable {
        case starButtonTapped(Int)
        case addPhotoButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .starButtonTapped(index):
                state.starRate = Double(index + 1)
                return .none
            case .addPhotoButtonTapped:
                return .none
            }
        }
    }
}
