//
//  AppDelegate.swift
//  CorkageFinder
//
//  Created by sungyeon on 12/9/24.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseModule

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      print("AppDelegate - Firebase configure 시작")
      print("AppDelegate - Firebase configure 완료")
    return true
  }
}

