import ComposableArchitecture
import Feature

@Reducer
struct AppFeature {
    struct State: Equatable {
        var tab1 = HomeFeature.State()
        var tab2 = MapFeature.State()
        var tab3 = RegisterRestaurantFeature.State()
        var tab4 = MypageFeature.State()
    }
    enum Action {
        case tab1(HomeFeature.Action)
        case tab2(MapFeature.Action)
        case tab3(RegisterRestaurantFeature.Action)
        case tab4(MypageFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            HomeFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            MapFeature()
        }
        Scope(state: \.tab3, action: \.tab3) {
            RegisterRestaurantFeature()
        }
        Scope(state: \.tab4, action: \.tab4) {
            MypageFeature()
        }

        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}
