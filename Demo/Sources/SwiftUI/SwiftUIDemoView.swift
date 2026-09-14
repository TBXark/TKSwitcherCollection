//
//  SwiftUIDemoView.swift
//  TKSwitcherCollectionDemo
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import SwiftUI
import TKSwitcherCollection

struct SwiftUIDemoView: View {

    @State private var simple1 = true
    @State private var simple2 = true
    @State private var simple3 = false
    @State private var simple4 = true
    @State private var exchange1 = true
    @State private var exchange2 = true
    @State private var smile = true
    @State private var liquid1 = true
    @State private var liquid2 = true

    var body: some View {
        List {
            Section("TKSimpleSwitch") {
                row("Default") {
                    TKSimpleSwitchView(isOn: $simple1)
                }
                row("Rotate") {
                    TKSimpleSwitchView(isOn: $simple2, rotateWhenValueChange: true)
                }
                row("Initial Off") {
                    TKSimpleSwitchView(isOn: $simple3)
                }
                row("Custom") {
                    TKSimpleSwitchView(
                        isOn: $simple4,
                        onColor: .systemIndigo,
                        lineColor: .systemIndigo.withAlphaComponent(0.4))
                }
            }
            Section("TKExchangeSwitch") {
                row("Default") {
                    TKExchangeSwitchView(isOn: $exchange1)
                }
                row("Custom") {
                    TKExchangeSwitchView(
                        isOn: $exchange2, onColor: .systemOrange, offColor: .systemBlue)
                }
            }
            Section("TKSmileSwitch") {
                row("Default") {
                    TKSmileSwitchView(isOn: $smile)
                }
            }
            Section("TKLiquidSwitch") {
                row("Default") {
                    TKLiquidSwitchView(isOn: $liquid1)
                }
                row("Custom") {
                    TKLiquidSwitchView(isOn: $liquid2, onColor: .systemPink, offColor: .systemGray4)
                }
            }
            Section {
                Button("Toggle All") {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        simple1.toggle()
                        simple2.toggle()
                        simple3.toggle()
                        simple4.toggle()
                        exchange1.toggle()
                        exchange2.toggle()
                        smile.toggle()
                        liquid1.toggle()
                        liquid2.toggle()
                    }
                }
            }
        }
        .navigationTitle("TKSwitcherCollection")
    }

    private func row<Switcher: View>(_ title: String, @ViewBuilder switcher: () -> Switcher)
        -> some View
    {
        HStack {
            Text(title)
            Spacer()
            switcher()
                .frame(width: 100, height: 50)
        }
    }
}

#Preview {
    SwiftUIDemoView()
}
