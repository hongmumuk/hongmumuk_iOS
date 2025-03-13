//
//  SearchFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import ComposableArchitecture
import SwiftUI

struct SearchFeature: Reducer {
    enum ActiveScreen: Equatable {
        case none, restrauntDetail(Int)
    }
    
    struct State: Equatable {
        var searchText = ""
        var isVisibleClearButton = false
        var activeScreen: ActiveScreen = .none
        var restrauntList = [RestaurantListModel]()
        var searchedList = [RestaurantListModel]()
        var recentSearchList = [String]()
        var isLoading = true
        var showEptyView = false
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case searchBarOnSubmit
        case searchBarOnChanged(String)
        case searchBarClearButtonTapped
        case recentSearchTapped(String)
        case recentSearchAllClearButtonTapped
        case recentSearchClearButtonTapped(String)
        case restrauntTapped(id: Int)
        case inquryButtonTapped
        case loadingCompleted
        case recentSearchesLoaded([String])
        case restrauntListLoaded([RestaurantListModel])
        case restrauntListError(RestaurantListError)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.restaurantClient) var restaurantClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let recentSearchList = await userDefaultsClient.getStringArray(.recentSearchList)
                    await send(.recentSearchesLoaded(recentSearchList))

                    do {
                        let body = RestaurantListRequestModel(category: .all, page: -1, sort: .name)
                        let searchList = try await restaurantClient.postRestaurantList(body)
                        await send(.restrauntListLoaded(searchList))
                    } catch {
                        if let error = error as? RestaurantListError {
                            await send(.restrauntListError(error))
                        }
                    }
                    await send(.loadingCompleted)
                }
                
            case .onDismiss:
                state.activeScreen = .none
                return .none
                
            case .searchBarOnSubmit:
                let query = state.searchText
                state.searchedList = state.restrauntList.filter { filterSearchList($0.name, query: query) }
                
                if state.searchedList.isEmpty {
                    state.showEptyView = true
                }
                
                return .run { send in
                    
                    // 1. 빈텍스트 필터
                    if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
                    
                    var recentSearchList = await userDefaultsClient.getStringArray(.recentSearchList)
                    
                    // 2. 중복된 검색어이면, 기존 아이템 삭제
                    if let existingIndex = recentSearchList.firstIndex(of: query) {
                        recentSearchList.remove(at: existingIndex)
                    }
                    
                    // 3. 10개 이상이면 마지막 요소, pop
                    if recentSearchList.count >= 10 {
                        recentSearchList.removeLast()
                    }
                    
                    // 4. push
                    recentSearchList.insert(query, at: 0)
                
                    await userDefaultsClient.setStringArray(recentSearchList, .recentSearchList)
                    await send(.recentSearchesLoaded(recentSearchList))
                }
                
            case let .searchBarOnChanged(searchText):
                let isEmptyText = searchText.isEmpty
                state.showEptyView = false
                state.searchText = searchText
                state.isVisibleClearButton = !isEmptyText
                
                if !isEmptyText {
                    state.searchedList = state.restrauntList.filter { filterSearchList($0.name, query: searchText) }
                } else {
                    state.searchedList = state.restrauntList
                }
                
                return .none
                
            case .searchBarClearButtonTapped:
                state.searchText = ""
                state.isVisibleClearButton = false
                state.searchedList = state.restrauntList
                return .none
                
            case let .recentSearchTapped(searchText):
                state.searchText = searchText
                state.searchedList = state.restrauntList.filter { filterSearchList($0.name, query: searchText) }
                
                if state.searchedList.isEmpty {
                    state.showEptyView = true
                }
                
                return .none
                
            case .recentSearchAllClearButtonTapped:
                return .run { send in
                    await userDefaultsClient.setStringArray([], .recentSearchList)
                    await send(.recentSearchesLoaded([]))
                }
                
            case let .recentSearchClearButtonTapped(text):
                return .run { send in
                    var recentSearchList = await userDefaultsClient.getStringArray(.recentSearchList)
                    recentSearchList.removeAll { $0 == text }
                    await userDefaultsClient.setStringArray(recentSearchList, .recentSearchList)
                    await send(.recentSearchesLoaded(recentSearchList))
                }
                
            case let .restrauntTapped(id):
                state.activeScreen = .restrauntDetail(id)
                return .none
                
            case .inquryButtonTapped:
                if let url = URL(string: "https://forms.gle/e8X1RPPJCDWkwj5JA") {
                    UIApplication.shared.open(url)
                }
                return .none
                
            case .loadingCompleted:
                state.isLoading = false
                return .none
                
            case let .recentSearchesLoaded(list):
                state.recentSearchList = list
                return .none
                
            case let .restrauntListLoaded(list):
                let sorted = list.sorted { $0.name < $1.name }
                state.restrauntList = sorted
                state.searchedList = sorted
                return .none
                
            case let .restrauntListError(error):
                // TODO: - 에러 처리
                return .none
            }
        }
    }
}

extension SearchFeature {
    // 검색 효율을 높이기 위한 필터링 장치
    func filterSearchList(_ restaurantName: String, query: String) -> Bool {
        // 1. 초성 검색 지원
        /// query와 식당이름을 초성으로 변경
        let queryChosung = query.convertToChosung()
        let nameChosung = restaurantName.convertToChosung()
        /// 입력이 초성일 경우에만 지원
        if query.isChosung() {
            /// 초성일 경우, 순서 고려
            /// 스위프트 -> 'ㅅㅇㅍㅌ' 가능, 'ㅇㅍㅌ' 불가능
            return nameChosung.hasPrefix(queryChosung)
        }

        // 2. 부분 문자열 검색
        /// 스위프트 -> '위프' 검색 가능
        if restaurantName.localizedCaseInsensitiveContains(query) {
            return true
        }
    
        // 3. 단어 단위 검색
        /// 공백 단위로 분리된 단어 배열
        let words = restaurantName.components(separatedBy: .whitespacesAndNewlines)
        /// 스위프트 코딩 -> '스위프트' 검색 가능
        if words.contains(where: { $0.localizedCaseInsensitiveContains(query) }) {
            return true
        }
        
        return false
    }
}
