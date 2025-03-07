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
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case pickerSelectionChanged(Int)
        case checkUser(String)
        case profileLoaded(TaskResult<ProfileModel>)
        
        case nickNameChanged(String)
        case nickNameFocused(Bool)
        case nickNameOnSubmit
        case nickNameTextClear
        
        case changeButtonTapped
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
                    state.nickNameErrorMessage = "이메일 인증이 완료되었습니다."
                }
                
                return .none

            case .nickNameTextClear:
                state.nickName = ""
                state.nickNameState = .empty
                state.nickNameErrorMessage = nil
                
                return .none

            case .changeButtonTapped:
                
                return .none
            }
        }
    }
}
