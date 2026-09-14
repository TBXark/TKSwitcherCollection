//
//  TKLiquidSwitchView.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import SwiftUI

/// SwiftUI wrapper of `TKLiquidSwitch`.
public struct TKLiquidSwitchView: UIViewRepresentable {

    @Binding private var isOn: Bool
    private var animationDuration: Double
    private var onColor: UIColor
    private var offColor: UIColor

    public init(
        isOn: Binding<Bool>,
        animationDuration: Double = 0.4,
        onColor: UIColor = UIColor(red: 0.373, green: 0.843, blue: 0.596, alpha: 1),
        offColor: UIColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1)
    ) {
        _isOn = isOn
        self.animationDuration = animationDuration
        self.onColor = onColor
        self.offColor = offColor
    }

    public func makeUIView(context: Context) -> TKLiquidSwitch {
        let view = TKLiquidSwitch()
        view.onValueChange = { [isOn = $isOn] value in
            isOn.wrappedValue = value
        }
        apply(to: view)
        view.setOn(isOn, animated: false)
        return view
    }

    public func updateUIView(_ view: TKLiquidSwitch, context: Context) {
        apply(to: view)
        let value = isOn
        if view.isOn != value {
            view.setOn(value, animated: context.transaction.animation != nil)
        }
    }

    private func apply(to view: TKLiquidSwitch) {
        view.animationDuration = animationDuration
        if view.onColor != onColor {
            view.onColor = onColor
        }
        if view.offColor != offColor {
            view.offColor = offColor
        }
    }
}
