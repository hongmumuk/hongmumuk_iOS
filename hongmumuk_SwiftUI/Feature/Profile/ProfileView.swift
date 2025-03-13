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
        .alert("로그인이 필요한 서비스입니다", isPresented: viewStore.binding(
            get: \.showLoginAlert,
            send: .loginAlertDismissed
        ),
        actions: {
            Button("취소", role: .none) {}
            
            Button("로그인", role: .none) {
                parentStore.send(.navigationTo(.emailLogin))
            }
        }, message: {
            Text("홍무묵의 모든 서비스를 이용하려면\n로그인이 필요합니다.")
        })
    }
}
