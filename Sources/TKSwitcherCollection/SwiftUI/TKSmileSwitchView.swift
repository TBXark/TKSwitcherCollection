//
//  TKSmileSwitchView.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import SwiftUI

/// SwiftUI wrapper of `TKSmileSwitch`.
public struct TKSmileSwitchView: UIViewRepresentable {

    @Binding private var isOn: Bool
    private var animationDuration: Double

    public init(
        isOn: Binding<Bool>,
        animationDuration: Double = 0.4
    ) {
        _isOn = isOn
        self.animationDuration = animationDuration
    }

    public func makeUIView(context: Context) -> TKSmileSwitch {
        let view = TKSmileSwitch()
        view.onValueChange = { [isOn = $isOn] value in
            isOn.wrappedValue = value
        }
        view.animationDuration = animationDuration
        view.setOn(isOn, animated: false)
        return view
    }

    public func updateUIView(_ view: TKSmileSwitch, context: Context) {
        view.animationDuration = animationDuration
        let value = isOn
        if view.isOn != value {
            view.setOn(value, animated: context.transaction.animation != nil)
        }
    }
}
