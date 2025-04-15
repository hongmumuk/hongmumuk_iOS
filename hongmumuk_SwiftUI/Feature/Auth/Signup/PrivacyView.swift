//
//  PrivacyView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct PrivacyView: View {
    let store: StoreOf<PrivacyFeature>
    let parentStore: StoreOf<RootFeature>
    @ObservedObject var viewStore: ViewStoreOf<PrivacyFeature>
    @ObservedObject var parentViewStore: ViewStoreOf<RootFeature>
    
    init(store: StoreOf<PrivacyFeature>, parentStore: StoreOf<RootFeature>) {
        self.store = store
        self.parentStore = parentStore
        viewStore = ViewStore(store, observe: { $0 })
        parentViewStore = ViewStore(parentStore, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                LoginHeaderView(title: "sign_up".localized(), action: { parentViewStore.send(.onDismiss) })
                
                SignupHeaderView(
                    activeStep: 1,
                    title: "agree_to_required_terms".localized(),
                    subtitle: "terms_agreement_required".localized()
                )
                
                allAgreeButton
                    .padding(.top, geometry.size.height * 0.056)
                    .padding(.horizontal, 24)
                
                HStack(alignment: .center) {
                    serviceAgreeButton
                    
                    Spacer()
                    
                    serviceModalButton
                        .padding(.trailing, 20)
                }
                .padding(.top, 22)
                .padding(.horizontal, 24)
                .frame(height: 56)
                
                HStack(alignment: .center) {
                    privacyAgreeButton
                    
                    Spacer()
                    
                    privacyModalButton
                        .padding(.trailing, 20)
                }
                .padding(.horizontal, 24)
                .frame(height: 56)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    SignupToastView(imageName: "checkWhiteIcon", title: "필수 약관 동의가 필요합니다")
                        .opacity(viewStore.isToastShown ? 1 : 0)
                        .animation(.easeOut(duration: 1.0), value: viewStore.isToastShown)
                        .frame(width: geometry.size.width * 0.6, height: 44)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)
                    
                    Spacer()
                }
                
                NextButton(
                    title: "다음으로",
                    isActive: viewStore.isContinueButtonEnabled,
                    action: {
                        viewStore.send(.continueButtonTapped)
                        parentViewStore.send(.navigationTo(.signupEmail))
                    }
                )
                .frame(height: 60)
                .padding(.horizontal, 24)
                .padding(.bottom, geometry.size.height * 0.1)
                .onTapGesture {
                    if !viewStore.isContinueButtonEnabled {
                        viewStore.send(.toastPresented)
                    }
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { viewStore.isServiceModalPresented },
            set: { _, _ in viewStore.send(.serviceModalDismissed) }
        )) {
            PrivacyModalView(
                title: "서비스 이용약관",
                content: "",
                onDismiss: {
                    viewStore.send(.serviceModalDismissed)
                },
                agreeAction: {
                    viewStore.send(.serviceAgree)
                    viewStore.send(.serviceModalDismissed)
                },
                urlString: ProfileSet.privacy.urlString
            )
        }
        .sheet(isPresented: Binding(
            get: { viewStore.isPrivacyModalPresented },
            set: { _, _ in viewStore.send(.privacyModalDismissed) }
        )) {
            PrivacyModalView(
                title: "개인정보 처리방침",
                content: "",
                onDismiss: {
                    viewStore.send(.privacyModalDismissed)
                },
                agreeAction: {
                    viewStore.send(.privacyAgree)
                    viewStore.send(.privacyModalDismissed)
                },
                urlString: ProfileSet.service.urlString
            )
        }
    }
    
    private var allAgreeButton: some View {
        Button(action: {
            viewStore.send(.allAgreeToggled)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Colors.GrayScale.grayscale5)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Colors.Border.normal)
                            .fill(Color.clear)
                    )
                
                HStack(alignment: .center, spacing: 12) {
                    Image(viewStore.allAgree ? "checkBlueIcon" : "checkIcon")
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                    Text("agree_all_terms".localized())
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundColor(Colors.GrayScale.normal)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var serviceAgreeButton: some View {
        Button(action: {
            viewStore.send(.serviceAgreeToggled)
        }) {
            ZStack {
                HStack(alignment: .center) {
                    Image(viewStore.serviceAgree ? "checkBlueIcon" : "checkIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 20)
                    
                    Text("agree_to_terms_of_service".localized())
                        .fontStyle(Fonts.heading3Medium)
                        .foregroundColor(Colors.GrayScale.normal)
                        .padding(.leading, 8)
                }
            }
        }
    }
    
    private var serviceModalButton: some View {
        Button(action: {
            viewStore.send(.serviceModalPresented)
        }) {
            Image("arrowIcon")
                .frame(width: 32, height: 32)
        }
    }
    
    private var privacyAgreeButton: some View {
        Button(action: {
            viewStore.send(.privacyAgreeToggled)
        }) {
            ZStack {
                HStack(alignment: .center) {
                    Image(viewStore.privacyAgree ? "checkBlueIcon" : "checkIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 20)
                    
                    Text("agree_to_privacy_policy".localized())
                        .fontStyle(Fonts.heading3Medium)
                        .foregroundColor(Colors.GrayScale.normal)
                        .padding(.leading, 8)
                }
            }
        }
    }
    
    private var privacyModalButton: some View {
        Button(action: {
            viewStore.send(.privacyModalPresented)
        }) {
            Image("arrowIcon")
                .frame(width: 32, height: 32)
        }
    }
}
