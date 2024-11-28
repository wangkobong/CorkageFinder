//
//  HomeFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture

@Reducer
public struct HomeFeature: Equatable {
    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false
        public var searchText: String = ""
        public var isSearching: Bool = false

        var path = StackState<CorkageListFeature.State>()
        
        public init() {}
    }
    
    public enum Action {
        case searchTextChanged(String)
        case searchingStateChanged(Bool)
        case search(String)
        case searchCancel
        case tapCategoryBox(HomeCategory)
        case path(StackAction<CorkageListFeature.State, CorkageListFeature.Action>)
    }
    
    public enum HomeCategory {
        case wine
        case baiju
        case etc
        
        var title: String {
            switch self {
            case .wine: return "와인"
            case .baiju: return "바이주"
            case .etc: return "기타"
            }
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                return .none
                
            case let .searchingStateChanged(isSearching):
                state.isSearching = isSearching
                return .none
                
            case let .search(searchedText):
                print("searchedText: \(searchedText)")
                return .none
                
            case .searchCancel:
                state.searchText = ""
                return .none
                
            case let .tapCategoryBox(category):
                state.path.append(CorkageListFeature.State(homeCategory: category))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            CorkageListFeature()
        }
    }
    
}
