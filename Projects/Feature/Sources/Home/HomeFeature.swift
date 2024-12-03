//
//  HomeFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture

@Reducer
public struct HomeFeature: Equatable {
    
    public static func == (lhs: HomeFeature, rhs: HomeFeature) -> Bool {
        return true
    }
    
    @Dependency(\.homeClient) var homeClient  // 의존성 주입

    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false
        public var searchText: String = ""
        public var isSearching: Bool = false
        public var recommenderRestaurants: [RestaurantCard] = []
        public var corkageFreeRestaurants: [RestaurantCard] = []

        public var path = StackState<Path.State>()
        
        public init() {}
    }
    
    public enum Action {
        case fetchHomeData
        case fetchHomeDataResponse(TaskResult<HomeData>)
        case searchTextChanged(String)
        case searchingStateChanged(Bool)
        case search(String)
        case searchCancel
        case tapCategoryBox(HomeRestaurantCategory)
        case path(StackActionOf<Path>)
        case restaurantDetailTap(RestaurantCard)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case categoryList(CorkageListFeature)
        case restaurantDetail(RestaurantDetailFeature)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchHomeData:
                state.isLoading = true
                return .run { [homeClient] send in
                    await send(.fetchHomeDataResponse(
                        TaskResult {
                            try await homeClient.fetch()
                        }
                    ))
                }
                
            case let .fetchHomeDataResponse(.success(homeData)):
                state.recommenderRestaurants = homeData.recommenderRestaurants
                state.corkageFreeRestaurants = homeData.corkageFreerestaurants
                return .none
                
            case let .fetchHomeDataResponse(.failure(error)):
                
                print("페치 실패: \(error)")
                return .none
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
                state.path.append(.categoryList(CorkageListFeature.State(homeCategory: category)))
                return .none
                
            case .path(_):
                return .none
                
            case let .restaurantDetailTap(restaurant):
                state.path.append(.restaurantDetail(RestaurantDetailFeature.State(restaurant: restaurant))) // 수정
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
}
