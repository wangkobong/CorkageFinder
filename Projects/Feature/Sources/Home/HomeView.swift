//
//  HomeView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

public struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                
                title
                    .padding(.top)
                
                categoryList
                
                Spacer()
            }
        } destination: { store in
            CorkageListView(store: store)
        }

    }
    
    private var title: some View {
        HStack {
            Text("테스트")
                .font(.largeTitle)
                .foregroundStyle(.black)
            
            Spacer()
        }
        .padding(.leading, 16)
    }
    
    private var categoryList: some View {
        HStack {
            HStack(spacing: 12) {
                // 와인 박스
                VStack {
                    Image(systemName: "wineglass.fill")
                        .font(.system(size: 24))
                        .padding(.bottom, 5)
                    Text("와인")
                        .font(.system(size: 14, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .onTapGesture {
                    store.send(.tapCategoryBox(.wine))
                }
                
                // 고량주 박스
                VStack {
                    Image(systemName: "drop.fill")  // 또는 "bottle.fill"
                        .font(.system(size: 24))
                        .padding(.bottom, 5)
                    Text("바이주")
                        .font(.system(size: 14, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .onTapGesture {
                    store.send(.tapCategoryBox(.baiju))
                }
                
                // 기타 박스
                VStack {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.system(size: 24))
                        .padding(.bottom, 5)
                    Text("기타")
                        .font(.system(size: 14, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .onTapGesture {
                    store.send(.tapCategoryBox(.etc))
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("검색어를 입력하세요", text: $store.searchText.sending(\.searchTextChanged))
                    .foregroundColor(.primary)
                    .onTapGesture {
                        store.send(.searchingStateChanged(true))
                    }
                
                if !store.searchText.isEmpty {
                    Button(action: {
                        store.send(.search(store.searchText))
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if store.isSearching {
                Button("취소") {
                    store.send(.searchCancel)
                    
                    // 키보드 내리기
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                 to: nil, from: nil, for: nil)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State()
        ) {
            HomeFeature()
        }
    )
}


