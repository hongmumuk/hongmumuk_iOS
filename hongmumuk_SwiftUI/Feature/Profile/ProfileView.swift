//
//  ProfileView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/18/25.
//

import SwiftUI

import ComposableArchitecture

struct ProfileView: View {
    private let store: StoreOf<ProfileFeature>
    private let parentStore: StoreOf<RootFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<ProfileFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<ProfileFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ProfileHeaderView(viewStore: viewStore)
                ProfileSetListView(viewStore: viewStore, parentViewStore: parentViewStore)
                Spacer()
            }
            
            VStack(spacing: 0) {
                Spacer()
                InquiryButton(action: {
                    viewStore.send(.inquryButtonTapped)
                }, showText: false)
            }
            .padding(.bottom, 52)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .alert("login_required_service".localized(), isPresented: viewStore.binding(
            get: \.showLoginAlert,
            send: .loginAlertDismissed
        ),
        actions: {
            Button("취소", role: .none) {}
            
            Button("login".localized(), role: .none) {
                parentStore.send(.navigationTo(.emailLogin))
            }
        }, message: {
            Text("login_required_all_services".localized())
        })
    }
}
