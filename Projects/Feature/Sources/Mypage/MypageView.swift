//
//  MypageView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

@MainActor
public struct MypageView: View {
    @Bindable var store: StoreOf<MypageFeature>
    
    public init(store: StoreOf<MypageFeature>) {
        self.store = store
    }
    
    private var loginTypeText: String {
        guard let type = store.loginedUser?.loginType else { return "" }
        
        switch type {
        case "구글": return "Google 계정"
        case "애플": return "Apple 계정"
        default: return "Google/Apple 계정"
        }
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                if store.loginedUser != nil {
                    authenticatedProfileView
                } else {
                    unauthenticatedProfileView
                }
                Spacer()
            }
            .navigationTitle("마이페이지")
            .onAppear {
                store.send(.checkAuthState)
            }
            
        } destination: { store in
            switch store.case {
            case let .approvalWatingList(state):
                ApprovalWaitingView(store: state)
            case let .restaurantDetail(state):
                RestaurantDetailView(store: state)
            }
        }
    }
    
}

//#Preview {
//    MypageView()
//}

/// 로그인 시
extension MypageView {
    private var authenticatedProfileView: some View {
        VStack {
            // 프로필 헤더
            profileSection
            
            // 메뉴 목록
            loginedMenuSection
            Divider()
            logoutSection
        }
        
    }
    
    @MainActor
    private var profileSection: some View {
        HStack(spacing: 15) {
            // 프로필 이미지
            Group {
                if let imageURL = store.loginedUser?.imageURL,
                   !imageURL.isEmpty,
                   let url = URL(string: imageURL) {
                    KFImage(url)
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                } else {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 40))
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
            }
            
            // 사용자 정보
            VStack(alignment: .leading, spacing: 6) {
                Text(store.loginedUser?.name ?? "이름 정보 없음")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(store.loginedUser?.userEmail ?? "유저 이메일 없음")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 6) {
                    Group {
                        if let loginType = store.loginedUser?.loginType {
                            switch loginType {
                            case "구글":
                                Image("google_logo")
                            case "애플":
                                Image(systemName: "applelogo")
                            case "구글애플":
                                HStack {
                                    Image("google_logo")
                                    Image(systemName: "applelogo")
                                }
                            case "애플구글":
                                HStack {
                                    Image(systemName: "applelogo")
                                    Image("google_logo")
                                }
                            default:
                                EmptyView()
                            }
                        }
                    }
                    Text(loginTypeText)
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var loginedMenuSection: some View {
        VStack(spacing: 0) {
            MypageMenuRow(icon: "bell", title: "알림 설정")
            Divider()
            MypageMenuRow(icon: "person.text.rectangle", title: "계정 관리")
            Divider()
            MypageMenuRow(icon: "doc.text", title: "이용 약관")
            Divider()
            MypageMenuRow(icon: "lock.shield", title: "개인정보 처리방침")
            if store.loginedUser?.isAdmin ?? false {
                Divider()
                MypageMenuRow(icon: "list.bullet", title: "신청 목록 확인")
                    .onTapGesture {
                        print("클릭됨")
                        store.send(.tapToApprovalWaitingList)
                    }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var logoutSection: some View {
        Button(action: {
            store.send(.logout)
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
                
                Text("로그아웃")
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }

}

/// 비 로그인 시
extension MypageView {
    
    private var unauthenticatedProfileView: some View {
        VStack {
            // 상단 이미지/텍스트 섹션
            topSection

            // 로그인 버튼
            loginButtonSection
            
            // 추가 정보 섹션
            termsSection
            
        }
    }
    
    private var topSection: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 50))
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5)
            
            VStack(spacing: 8) {
                Text("로그인이 필요합니다")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("로그인하고 더 많은 기능을 이용해보세요")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var loginButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                store.send(.login(.google))
            }) {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Google로 계속하기")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
            
            Button(action: {
                store.send(.login(.apple))

            }) {
                HStack {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Apple로 계속하기")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
    
    private var termsSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                // 이용약관 액션
            }) {
                Text("이용약관 및 개인정보처리방침")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .underline()
            }
        }
        .padding(.top, 12)
    }
}

