//
//  ReviewMakeFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import ComposableArchitecture

struct ReviewMakeFeature: Reducer {
    struct State: Equatable {}
    
    enum Action: Equatable {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
