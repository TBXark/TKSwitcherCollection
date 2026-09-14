//
//  TKSimpleSwitchView.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

// SwiftUI 版本. 基于 `UIViewRepresentable` 封装 UIKit 实现, 保证动画效果一致.

import SwiftUI

/// SwiftUI wrapper of `TKSimpleSwitch`.
public struct TKSimpleSwitchView: UIViewRepresentable {

    @Binding private var isOn: Bool
    private var animationDuration: Double
    private var rotateWhenValueChange: Bool
    private var onColor: UIColor
    private var offColor: UIColor
    private var lineColor: UIColor
    private var circleColor: UIColor
    private var lineSize: Double

    public init(
        isOn: Binding<Bool>,
        animationDuration: Double = 0.4,
        rotateWhenValueChange: Bool = false,
        onColor: UIColor = UIColor(red: 0.341, green: 0.914, blue: 0.506, alpha: 1),
        offColor: UIColor = UIColor(white: 0.9, alpha: 1),
        lineColor: UIColor = UIColor(white: 0.8, alpha: 1),
        circleColor: UIColor = UIColor.white,
        lineSize: Double = 10
    ) {
        _isOn = isOn
        self.animationDuration = animationDuration
        self.rotateWhenValueChange = rotateWhenValueChange
        self.onColor = onColor
        self.offColor = offColor
        self.lineColor = lineColor
        self.circleColor = circleColor
        self.lineSize = lineSize
    }

    public func makeUIView(context: Context) -> TKSimpleSwitch {
        let view = TKSimpleSwitch()
        view.onValueChange = { [isOn = $isOn] value in
            isOn.wrappedValue = value
        }
        apply(to: view)
        view.setOn(isOn, animated: false)
        return view
    }

    public func updateUIView(_ view: TKSimpleSwitch, context: Context) {
        apply(to: view)
        let value = isOn
        if view.isOn != value {
            view.setOn(value, animated: context.transaction.animation != nil)
        }
    }

    private func apply(to view: TKSimpleSwitch) {
        view.animationDuration = animationDuration
        if view.rotateWhenValueChange != rotateWhenValueChange {
            view.rotateWhenValueChange = rotateWhenValueChange
        }
        if view.onColor != onColor {
            view.onColor = onColor
        }
        if view.offColor != offColor {
            view.offColor = offColor
        }
        if view.lineColor != lineColor {
            view.lineColor = lineColor
        }
        if view.circleColor != circleColor {
            view.circleColor = circleColor
        }
        if view.lineSize != lineSize {
            view.lineSize = lineSize
        }
    }
}
