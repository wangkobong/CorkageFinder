//
//  CategoryFeature.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import ComposableArchitecture
import Models
import PhotosUI
import SwiftUI

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
        public var name: String = ""
        public var category: HomeRestaurantCategory = .korean // 기본값 설정 필요
        public var isCorkageFree: Bool = false
        public var corkageFee: String = ""
        public var sido: String = ""
        public var sigungu: String = ""
        public var phoneNumber: String = ""
        public var address: String = ""
        public var addressDetail: String = ""
        public var closedDays: String = ""
        public var corkageNote: String = ""
        public var validateAddress: String = ""
        public var businessHours: String = ""
        public var breaktime: String = ""
        public var latitude: String = ""
        public var longitude: String = ""
        public var isBreaktime: Bool = false
        public var selectedItems: [PhotosPickerItem] = []
        public var selectedImages: [UIImage] = []
        public var openTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
        public var closeTime: Date = Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date()
        public var breakStartTime: Date = Calendar.current.date(from: DateComponents(hour: 14, minute: 0)) ?? Date()
        public var breakEndTime: Date = Calendar.current.date(from: DateComponents(hour: 15, minute: 0)) ?? Date()
        
        var isSubmitButtonEnabled: Bool {
            let enabled = !name.isEmpty &&
                !phoneNumber.isEmpty &&
                isLocationValid

            return enabled
        }

        
        var isLocationValid: Bool {
            !validateAddress.isEmpty && validateAddress != "정확한 주소를 입력해주세요."  && !latitude.isEmpty && !longitude.isEmpty
        }
        
        var fullAddress: String {
            get {
                return validateAddress + " " + addressDetail
            }
            set {
                validateAddress = newValue
            }
        }
        
        var computedBusinessHours: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return "\(formatter.string(from: openTime)) ~ \(formatter.string(from: closeTime))"
        }
        
        var computedBreaktime: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return "\(formatter.string(from: breakStartTime)) ~ \(formatter.string(from: breakEndTime))"
        }
        
        public init() {}
    }
    
    public enum Action {
        case nameChanged(String)
        case categoryChanged(HomeRestaurantCategory)
        case isCorkageFreeChanged(Bool)
        case corkageFeeChanged(String)
        case corkageNoteChanged(String)
        case sidoChanged(String)
        case sigunguChanged(String)
        case addressChanged(String)
        case addressDetailChanged(String)
        case phoneNumberChanged(String)
        case closedDaysChanged(String)
        case saveButtonTapped
        case saveFailed(Error)
        case validateAdress(String)
        case validateAdressResponse(TaskResult<GeocodingResponse>)
        case alert(PresentationAction<Alert>)
        case isBreakTime(Bool)
        case updateSelectedItems([PhotosPickerItem])
        case processSelectedItem(PhotosPickerItem)
        case imageLoaded(UIImage)
        case removeImage(Int)
        case openTimeChanged(Date)
        case closeTimeChanged(Date)
        case breakStartTimeChanged(Date)
        case breakEndTimeChanged(Date)

        public enum Alert: Equatable {
            case completeSave
            case saveConfirmed
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .updateSelectedItems(items):
                state.selectedItems = items
                state.selectedImages = []  // 이미지 배열 초기화
                return .run { send in
                    for item in items {
                        await send(.processSelectedItem(item))
                    }
                }
                
            case let .processSelectedItem(item):
                return .run { send in
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await send(.imageLoaded(image))
                    }
                }
                
            case let .removeImage(index):
                state.selectedItems.remove(at: index)
                state.selectedImages.remove(at: index)
                return .none
                
            case let .imageLoaded(image):
                  state.selectedImages.append(image)
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
                
            case let .addressDetailChanged(addressDetail):
                state.addressDetail = addressDetail
                return .none
                
            case let .phoneNumberChanged(phoneNumber):
                state.phoneNumber = phoneNumber.filter { $0.isNumber }
                return .none

            case let .closedDaysChanged(closedDays):
                state.closedDays = closedDays
                return .none
                
            case let .isBreakTime(isBreaktime):
                state.isBreaktime = isBreaktime
                return .none
                
            case .saveButtonTapped:
                state.isLoading = true
                state.businessHours = state.computedBusinessHours
                state.breaktime = state.computedBreaktime
                return .run { [state] send in
                    do {
                        // 이미지가 있을 때만 업로드 수행
                        let urls: [String]
                        if !state.selectedImages.isEmpty {
                            urls = try await registerRestaurantClient.saveImages(state.selectedImages)
                        } else {
                            urls = []  // 이미지가 없으면 빈 배열 사용
                        }

                        let restaurant = RestaurantCard(
                            imageURLs: urls,
                            name: state.name,
                            category: state.category,
                            isCorkageFree: state.isCorkageFree,
                            corkageFee: state.corkageFee,
                            sido: state.sido,
                            sigungu: state.sigungu,
                            phoneNumber: state.phoneNumber,
                            address: state.fullAddress,
                            addressDetail: state.addressDetail,
                            businessHours: state.businessHours,
                            closedDays: state.closedDays,
                            corkageNote: state.corkageNote,
                            latitude: Double(state.latitude) ?? 0.0,
                            longitude: Double(state.longitude) ?? 0.0,
                            isBreaktime: state.isBreaktime,
                            breaktime: state.breaktime
                        )
                        
                        let success = try await registerRestaurantClient.saveRestaurant(restaurant)
                        await send(success ? .alert(.presented(.completeSave)) : .saveFailed(HTTPError.invalidResponse))
                    } catch {
                        await send(.saveFailed(error))
                    }
                }

            case let .saveFailed(error):
                print("세이브실패 : \(error)")
                state.isLoading = false
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
                    let data = geocodingResponse.documents[0].address
                    state.sido = data.region1depthName
                    state.sigungu = data.region2depthName
                    state.validateAddress = geocodingResponse.documents[0].addressName
                    state.latitude = data.y
                    state.longitude = data.x
                    state.isLoading = false
                    return .none
                } else {
                    state.validateAddress = "정확한 주소를 입력해주세요."
                }
                state.isLoading = false
                return .none
                
            case let .validateAdressResponse(.failure(error)):
                print("지오코딩 실패: \(error)")
                state.isLoading = false
                return .none
        
            case let .alert(.presented(alertAction)):
                state.isLoading = false
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
                    state.selectedImages = []
                    state.name = ""
                    state.category = .korean
                    state.isCorkageFree = false
                    state.corkageFee = ""
                    state.sido = ""
                    state.sigungu = ""
                    state.phoneNumber = ""
                    state.address = ""
                    state.addressDetail = ""
                    state.fullAddress = ""
                    state.businessHours = ""
                    state.closedDays = ""
                    state.corkageNote = ""
                    state.validateAddress = ""
                    state.latitude = ""
                    state.longitude = ""
                    state.isBreaktime = false
                    state.breaktime = ""
                    state.openTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
                    state.closeTime = Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date()
                    state.isLoading = false

                    return .none
                }
                
            case .alert:
                if state.alert == nil { return .none }
                return .none
            case let .openTimeChanged(openTime):
                state.openTime = openTime
                return .none
            case let .closeTimeChanged(closeTime):
                state.closeTime = closeTime
                return .none
            case let .breakStartTimeChanged(breakStartTime):
                state.breakStartTime = breakStartTime
                return .none
            case let .breakEndTimeChanged(breakEndTime):
                state.breakEndTime = breakEndTime
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
