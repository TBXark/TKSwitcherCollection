//
//  DemoTabBarController.swift
//  TKSwitcherCollectionDemo
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import SwiftUI
import TKSwitcherCollection
import UIKit

final class DemoTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let uiKit = UINavigationController(rootViewController: UIKitDemoViewController())
        uiKit.tabBarItem = UITabBarItem(
            title: "UIKit", image: UIImage(systemName: "switch.2"), tag: 0)

        let swiftUI = UIHostingController(rootView: SwiftUIDemoView())
        swiftUI.tabBarItem = UITabBarItem(
            title: "SwiftUI", image: UIImage(systemName: "sparkles"), tag: 1)

        viewControllers = [uiKit, swiftUI]

        // `xcrun simctl launch <bundle> swiftui` 直接打开 SwiftUI 演示页
        if ProcessInfo.processInfo.arguments.contains("swiftui") {
            selectedIndex = 1
        }
    }
}
