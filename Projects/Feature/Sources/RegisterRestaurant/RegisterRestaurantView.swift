//
//  CategoryView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import Models
import PhotosUI

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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text("이미지 선택")
                                .font(.headline)
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            ForEach(Array(store.selectedImages.enumerated()), id: \.offset) { index, image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        Button(action: {
                                            store.send(.removeImage(index))
                                            
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        .padding(4),
                                        alignment: .topTrailing
                                    )
                            }
                            .transition(.scale.combined(with: .opacity))  // 전환 효과 추가
                            
                            PhotosPicker(
                                selection: Binding(
                                    get: { store.selectedItems },
                                    set: { store.send(.updateSelectedItems($0)) }
                                ),
                                maxSelectionCount: 3,
                                matching: .images
                            ) {
                                VStack {
                                    Image(systemName: "plus")
                                        .font(.system(size: 30))
                                    Text("사진 추가")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                                )
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: store.selectedImages)
                        .padding(.vertical, 8)
                    }
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
                    TextField("주소", text: $store.address.sending(\.addressChanged))
                    // 검증된 주소가 있을 경우 표시
                    if store.state.validateAddress == "정확한 주소를 입력해주세요." {

                        Text("정확한 주소를 입력해주세요.")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if store.state.validateAddress != "" {
                        TextField("상세주소", text: $store.addressDetail.sending(\.addressDetailChanged))
                        Text(store.state.fullAddress)
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
                    HStack {
                         Text("영업시간")
                         Spacer()
                         DatePicker(
                             "시작",
                             selection: $store.openTime.sending(\.openTimeChanged),
                             displayedComponents: .hourAndMinute
                         )
                         .labelsHidden()
                         
                         Text("~")
                         
                         DatePicker(
                             "종료",
                             selection: $store.closeTime.sending(\.closeTimeChanged),
                             displayedComponents: .hourAndMinute
                         )
                         .labelsHidden()
                     }
                     
                     TextField("휴무일", text: $store.closedDays.sending(\.closedDaysChanged))
                     Toggle("브레이크타임", isOn: $store.isBreaktime.sending(\.isBreakTime))
                     if store.isBreaktime {
                         HStack {
                             Text("브레이크타임")
                             Spacer()
                             DatePicker(
                                 "시작",
                                 selection: $store.breakStartTime.sending(\.breakStartTimeChanged),
                                 displayedComponents: .hourAndMinute
                             )
                             .labelsHidden()
                             
                             Text("~")
                             
                             DatePicker(
                                 "종료",
                                 selection: $store.breakEndTime.sending(\.breakEndTimeChanged),
                                 displayedComponents: .hourAndMinute
                             )
                             .labelsHidden()
                         }
                     }
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
            .alert($store.scope(state: \.alert, action: \.alert))

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
