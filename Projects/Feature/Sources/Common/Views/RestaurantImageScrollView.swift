//
//  RestaurantImageScrollView.swift
//  Feature
//
//  Created by sungyeon on 12/19/24.
//

import SwiftUI
import Kingfisher
import Models

struct RestaurantImageCarouselWithPaging: View {
    let imageURLs: [String]
    @State private var currentIndex = 0
    @State private var isLoading = true
    @State private var loadedImages = Set<String>()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            if imageURLs.isEmpty {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .onAppear { isLoading = false }  // 이미지가 없으면 로딩 상태를 false로
            } else {
                ForEach(Array(imageURLs.enumerated()), id: \.element) { index, urlString in
                    KFImage(URL(string: urlString))
                        .onSuccess { _ in
                            loadedImages.insert(urlString)
                            isLoading = loadedImages.count != imageURLs.count
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                        .tag(index)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 250)
        .loadingOverlay(isLoading: isLoading)
    }
}
#Preview {
    RestaurantImageCarouselWithPaging(imageURLs: RestaurantCard.preview.imageURLs)
}
