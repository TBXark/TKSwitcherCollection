//
//  TKExchangeSwitchView.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import SwiftUI

/// SwiftUI wrapper of `TKExchangeSwitch`.
public struct TKExchangeSwitchView: UIViewRepresentable {

    @Binding private var isOn: Bool
    private var animationDuration: Double
    private var lineColor: UIColor
    private var onColor: UIColor
    private var offColor: UIColor
    private var lineSize: Double

    public init(
        isOn: Binding<Bool>,
        animationDuration: Double = 0.4,
        lineColor: UIColor = UIColor(white: 0.95, alpha: 1),
        onColor: UIColor = UIColor(red: 0.34, green: 0.91, blue: 0.51, alpha: 1.00),
        offColor: UIColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00),
        lineSize: Double = 20
    ) {
        _isOn = isOn
        self.animationDuration = animationDuration
        self.lineColor = lineColor
        self.onColor = onColor
        self.offColor = offColor
        self.lineSize = lineSize
    }

    public func makeUIView(context: Context) -> TKExchangeSwitch {
        let view = TKExchangeSwitch()
        view.onValueChange = { [isOn = $isOn] value in
            isOn.wrappedValue = value
        }
        apply(to: view)
        view.setOn(isOn, animated: false)
        return view
    }

    public func updateUIView(_ view: TKExchangeSwitch, context: Context) {
        apply(to: view)
        let value = isOn
        if view.isOn != value {
            view.setOn(value, animated: context.transaction.animation != nil)
        }
    }

    private func apply(to view: TKExchangeSwitch) {
        view.animationDuration = animationDuration
        if view.lineColor != lineColor {
            view.lineColor = lineColor
        }
        if view.onColor != onColor {
            view.onColor = onColor
        }
        if view.offColor != offColor {
            view.offColor = offColor
        }
        if view.lineSize != lineSize {
            view.lineSize = lineSize
        }
    }
}
