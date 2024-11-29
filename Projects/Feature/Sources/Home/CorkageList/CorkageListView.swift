//
//  CorkageListView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

struct CorkageListView: View {
    
    @Bindable var store: StoreOf<CorkageListFeature>
    
    public init(store: StoreOf<CorkageListFeature>) {
        self.store = store
    }
    
    var body: some View {
        Form {
        }
        .navigationTitle(Text(store.homeCategory.title))
    }
}

#Preview {
    CorkageListView(
        store: Store(
            initialState: CorkageListFeature.State(homeCategory: .korean)
        ) {
            CorkageListFeature()
        }
    )
}
