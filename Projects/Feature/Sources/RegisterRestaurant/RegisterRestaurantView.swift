//
//  CategoryView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import Models

public struct RegisterRestaurantView: View {
    @Bindable var store: StoreOf<RegisterRestaurantFeature>
        
    public init(store: StoreOf<RegisterRestaurantFeature>) {
        self.store = store
    }
    
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("기본 정보")) {
//                    TextField("이미지", text: $store.imageURL.sending(\.imageURLChanged))
                    TextField("레스토랑 이름", text: $store.name.sending(\.nameChanged))
                    Picker("카테고리", selection: $store.category.sending(\.categoryChanged)) {
                        ForEach(HomeRestaurantCategory.allCases, id: \.self) { category in
                            Text(category.title).tag(category)
                        }
                    }
                }
                
                Section(header: Text("콜키지 정보")) {
                    Toggle("콜키지 무료", isOn: $store.isCorkageFree.sending(\.isCorkageFreeChanged))
                    if !store.isCorkageFree {
                        TextField("콜키지 비용", text: $store.corkageFee.sending(\.corkageFeeChanged))
                    }
                    TextField("콜키지 관련 메모", text: $store.corkageNote.sending(\.corkageNoteChanged))
                }
                
                Section(header: Text("위치 정보")) {
//                    TextField("시/도", text: $store.sido.sending(\.sidoChanged))
//                    TextField("시/군/구", text: $store.sigungu.sending(\.sigunguChanged))
                    TextField("주소", text: $store.address.sending(\.addressChanged))
                    // 검증된 주소가 있을 경우 표시
                    if store.state.validateAddress == "정확한 주소를 입력해주세요." {
                        Text("정확한 주소를 입력해주세요.")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if store.state.validateAddress != "" {
                        Text(store.state.validateAddress)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Button {
                        store.send(.validateAdress(store.address))
                    } label: {
                        Text("주소 검색")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                }
                
                Section(header: Text("연락처 및 영업시간")) {
                    TextField("전화번호", text: $store.phoneNumber.sending(\.phoneNumberChanged))
                    TextField("영업시간", text: $store.businessHours.sending(\.businessHoursChanged))
                    TextField("휴무일", text: $store.closedDays.sending(\.closedDaysChanged))
                }
                
                
                Button {
                    store.send(.saveButtonTapped)
                } label: {
                    Text("저장하기")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(store.isSubmitButtonEnabled ? Color.blue : Color.gray.opacity(0.5))
                .disabled(!store.isSubmitButtonEnabled)

            }
            .navigationTitle("레스토랑 정보 입력")
        }
    }
}

#Preview {
    RegisterRestaurantView(
        store: Store(
            initialState: RegisterRestaurantFeature.State()
        ) {
            RegisterRestaurantFeature()
        }
    )
}
