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
    @Dependency(\.kakaoGeocodingClient) var geocodingClient
    
    @ObservableState
    public struct State: Equatable {
        
        @Presents var alert: AlertState<Action.Alert>?
        
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
        public var validateAddress: String = ""
        public var latitude: String = ""
        public var longitude: String = ""
        public var isBreaktime: Bool = false
        public var breaktime: String = ""
        
        var isSubmitButtonEnabled: Bool {
            !name.isEmpty &&
            !phoneNumber.isEmpty &&
            !businessHours.isEmpty &&
            !closedDays.isEmpty &&
            isLocationValid
        }
        
        var isLocationValid: Bool {
            !validateAddress.isEmpty && validateAddress != "정확한 주소를 입력해주세요."  && !latitude.isEmpty && !longitude.isEmpty
        }
        
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
        case validateAdress(String)
        case validateAdressResponse(TaskResult<GeocodingResponse>)
        case alert(PresentationAction<Alert>)
        case isBreakTime(Bool)
        case breaktime(String)

        public enum Alert: Equatable {
            case completeSave
            case saveConfirmed
        }
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
                
            case let .isBreakTime(isBreaktime):
                state.isBreaktime = isBreaktime
                return .none
                
            case let .breaktime(breaktime):
                state.breaktime = breaktime
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
                        corkageNote: state.corkageNote,
                        latitude: Double(state.latitude) ?? 0.0,
                        longitude: Double(state.longitude) ?? 0.0,
                        isBreaktime: state.isBreaktime,
                        breaktime: state.breaktime
                    )
                    
                    do {
                        let success = try await registerRestaurantClient.saveRestaurant(restaurant)
                        await send(success ? .alert(.presented(.completeSave)) : .saveFailed(HTTPError.invalidResponse))
                    } catch {
                        await send(.saveFailed(error))
                    }
                }
                
            case let .saveFailed(error):
                print("세이브실패 : \(error)")
                return .none
                
            case let .validateAdress(address):
                state.isLoading = true
                return .run { [geocodingClient] send in
                    await send(.validateAdressResponse(
                        TaskResult {
                            try await geocodingClient.fetchAddressInfo(address)
                        }
                    ))
                }
            case let .validateAdressResponse(.success(geocodingResponse)):
                if geocodingResponse.documents.count == 1 {
                    print("지오코딩 성공")
                    print("\(geocodingResponse.documents[0].address)")
                    let data = geocodingResponse.documents[0].address
                    state.sido = data.region1depthName
                    state.sigungu = data.region2depthName
                    state.validateAddress = geocodingResponse.documents[0].addressName
                    state.latitude = data.y
                    state.longitude = data.x
                    return .none
                } else {
                    state.validateAddress = "정확한 주소를 입력해주세요."
                }
                return .none
                
            case let .validateAdressResponse(.failure(error)):
                print("지오코딩 실패: \(error)")
                return .none
                
            case let .alert(.presented(alertAction)):
                
                switch alertAction {
                case .completeSave:
                    state.alert = AlertState {
                        TextState("등록 신청 완료")
                    } actions: {
                        ButtonState(role: .cancel, action: .saveConfirmed) {
                            TextState("확인")
                        }
                    }
                    return .none
                    
                case .saveConfirmed:
                    print("식당 저장 성공")
                    state.isLoading = false
                    state.imageURL = ""
                    state.name = ""
                    state.category = .korean
                    state.isCorkageFree = false
                    state.corkageFee = ""
                    state.sido = ""
                    state.sigungu = ""
                    state.phoneNumber = ""
                    state.address = ""
                    state.businessHours = ""
                    state.closedDays = ""
                    state.corkageNote = ""
                    state.validateAddress = ""
                    state.latitude = ""
                    state.longitude = ""
                    return .none
                }
                
            case .alert:
                if state.alert == nil { return .none }
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
