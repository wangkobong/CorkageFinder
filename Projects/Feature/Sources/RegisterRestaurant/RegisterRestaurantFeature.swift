//
//  CategoryFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture
import Models

@Reducer
public struct RegisterRestaurantFeature: Equatable {
    
    public static func == (lhs: RegisterRestaurantFeature, rhs: RegisterRestaurantFeature) -> Bool {
        return true
    }
    
    @Dependency(\.registerRestaurantClient) var registerRestaurantClient  // 저장 API 클라이언트 의존성 추가

    @ObservableState
    public struct State: Equatable {
        public var isLoading = false
        public var isTimerRunning = false

        public var imageURL: String = ""
        public var name: String = ""
        public var category: HomeRestaurantCategory = .korean // 기본값 설정 필요
        public var isCorkageFree: Bool = false
        public var corkageFee: String = ""
        public var sido: String = ""
        public var sigungu: String = ""
        public var phoneNumber: String = ""
        public var address: String = ""
        public var businessHours: String = ""
        public var closedDays: String = ""
        public var corkageNote: String = ""
        
        public init() {}
    }
    
    public enum Action {
        case imageURLChanged(String)
        case nameChanged(String)
        case categoryChanged(HomeRestaurantCategory)
        case isCorkageFreeChanged(Bool)
        case corkageFeeChanged(String)
        case corkageNoteChanged(String)
        case sidoChanged(String)
        case sigunguChanged(String)
        case addressChanged(String)
        case phoneNumberChanged(String)
        case businessHoursChanged(String)
        case closedDaysChanged(String)
        case saveButtonTapped
        case saveFailed(Error)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .imageURLChanged(imageURL):
                state.imageURL = imageURL
                return .none
                
            case let .nameChanged(name):
                state.name = name
                return .none
                
            case let .categoryChanged(category):
                state.category = category
                return .none
                
            case let .isCorkageFreeChanged(isCorkageFree):
                state.isCorkageFree = isCorkageFree
                return .none
                
            case let .corkageFeeChanged(corkageFee):
                state.corkageFee = corkageFee
                return .none
                
            case let .corkageNoteChanged(corkageNote):
                state.corkageNote = corkageNote
                return .none
                
            case let .sidoChanged(sido):
                state.sido = sido
                return .none
                
            case let .sigunguChanged(sigungu):
                state.sigungu = sigungu
                return .none
                
            case let .addressChanged(address):
                state.address = address
                return .none
                
            case let .phoneNumberChanged(phoneNumber):
                state.phoneNumber = phoneNumber
                return .none
                
            case let .businessHoursChanged(businessHour):
                state.businessHours = businessHour
                return .none
                
            case let .closedDaysChanged(closedDays):
                state.closedDays = closedDays
                return .none
                
            case .saveButtonTapped:
                state.isLoading = true  // 저장 중임을 표시
                
                return .run { [state] send in
                    // 저장 API 호출
                    let restaurant = RestaurantCard(
                        imageURL: state.imageURL,
                        name: state.name,
                        category: state.category,
                        isCorkageFree: state.isCorkageFree,
                        corkageFee: state.corkageFee,
                        sido: state.sido,
                        sigungu: state.sigungu,
                        phoneNumber: state.phoneNumber,
                        address: state.address,
                        businessHours: state.businessHours,
                        closedDays: state.closedDays,
                        corkageNote: state.corkageNote
                    )
                    
                    do {
                        try await registerRestaurantClient.saveRestaurant(restaurant)
                        await print("완료")
                    } catch {
                        await send(.saveFailed(error))
                    }
                }
                
            case let .saveFailed(error):
                print("세이브실패 : \(error)")
                return .none
                
            }
        }
    }
}
