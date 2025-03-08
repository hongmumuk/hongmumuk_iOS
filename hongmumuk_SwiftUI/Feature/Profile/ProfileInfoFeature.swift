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
        var profile: ProfileModel = .mock()
        
        var nickName: String = ""
        var nickNameState: TextFieldState = .empty
        var nickNameErrorMessage: String? = nil
        
        var todayString = ""
        var token: String = ""
        
        var showLogoutAlert = false
        var showWithdrawAlert = false
        
        var pop = false
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case pickerSelectionChanged(Int)
        case checkUser(String)
        
        case profileLoaded(TaskResult<ProfileModel>)
        case nickNameLoaded(TaskResult<Bool>)
        case deleteAccountLoaded(TaskResult<Bool>)
        case logoutLoaded
        case toRoot
        
        case nickNameChanged(String)
        case nickNameFocused(Bool)
        case nickNameOnSubmit
        case nickNameTextClear
        
        case changeButtonTapped
        case logoutButtonTapped
        case logoutConfirmButtonTapped
        case withdrawButtonTapped
        case withdrawConfirmButtonTapped
        case alertDismiss
    }
    
    @Dependency(\.profileClient) var profileClient
    @Dependency(\.keychainClient) var keychainClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let today = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy. MM. dd"
                let formattedDate = formatter.string(from: today)
                state.todayString = formattedDate
                
                return .run { send in
                    if let token = await keychainClient.getString(.accessToken) {
                        await send(.checkUser(token))
                    }
                }
                
            case .onDismiss:
                return .none
                
            case let .checkUser(token):
                state.token = token
                return .run { [token = token] send in
                    let result = await TaskResult {
                        try await profileClient.getProfile(token)
                    }
                    
                    await send(.profileLoaded(result))
                }
                
            case let .pickerSelectionChanged(index):
                state.pickerSelection = index
                return .none
                
            case let .profileLoaded(.success(profile)):
                state.profile = profile
                state.nickName = profile.nickName
                
                return .none
                
            case let .profileLoaded(.failure(error)):
                print(error)
                // TODO: 에러 처리
                return .none
                
            case let .nickNameChanged(nickName):
                state.nickName = nickName
                return .none

            case let .nickNameFocused(isFocused):
                state.nickNameState = isFocused ? .focused : (state.nickName.isEmpty ? .empty : .normal)
                state.nickNameErrorMessage = nil
                return .none

            case .nickNameOnSubmit:
                if state.profile.nickName == state.nickName {
                    state.nickNameState = .invalid
                    state.nickNameErrorMessage = "기존 닉네임과 동일합니다."
                } else {
                    state.nickNameState = .nicknameVerified
                    state.nickNameErrorMessage = "사용 가능한 닉네임입니다."
                }
                
                return .none

            case .nickNameTextClear:
                state.nickName = ""
                state.nickNameState = .empty
                state.nickNameErrorMessage = nil
                
                return .none

            case .changeButtonTapped:
                let nickname = state.nickName
                let token = state.token
                
                return .run { send in
                    let result = await TaskResult {
                        try await profileClient.patchNickName(token, nickname)
                    }
                    
                    await send(.nickNameLoaded(result))
                }
                
            case let .nickNameLoaded(.success(_)):
                state.profile.nickName = state.nickName
                return .none
                
            case let .nickNameLoaded(.failure(error)):
                let error = error as? NickNameError ?? .unknown
                
                if error == .duplicate {
                    state.nickNameState = .invalid
                    state.nickNameErrorMessage = "이미 사용 중인 닉네임입니다."
                }
                
                return .none
                
            case .logoutButtonTapped:
                state.showLogoutAlert = true
                return .none
                
            case .logoutConfirmButtonTapped:
                return .run { send in
                    await keychainClient.remove(.accessToken)
                    await keychainClient.remove(.refreshToken)
                    
                    await send(.logoutLoaded)
                }

            case .withdrawButtonTapped:
                state.showWithdrawAlert = true
                return .none
                
            case .withdrawConfirmButtonTapped:
                let token = state.token
                
                return .run { send in
                    let result = await TaskResult {
                        try await profileClient.deleteAccount(token)
                    }
                    
                    await send(.deleteAccountLoaded(result))
                }
                
            case .deleteAccountLoaded(.success(_)):
                print("탈퇴 성공")
                return .run { send in
                    await keychainClient.remove(.accessToken)
                    await keychainClient.remove(.refreshToken)
                    await send(.toRoot)
                }
                
            case .toRoot:
                state.pop = true
                return .none
                
            case let .deleteAccountLoaded(.failure(error)):
                print("탈퇴 실패", error)
                // TODO: 에러 처리
                return .none
                
            case .alertDismiss:
                state.showLogoutAlert = false
                state.showWithdrawAlert = false
                return .none
                
            case .logoutLoaded:
                state.pop = true
                return .none
            }
        }
    }
}
