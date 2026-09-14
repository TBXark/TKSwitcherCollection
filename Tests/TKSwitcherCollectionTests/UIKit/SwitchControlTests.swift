//
//  SwitchControlTests.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import UIKit
import XCTest

@testable import TKSwitcherCollection

@MainActor
final class SwitchControlTests: XCTestCase {

    // MARK: - State semantics

    func testInitialStateIsOn() {
        XCTAssertTrue(TKSimpleSwitch().isOn)
        XCTAssertTrue(TKExchangeSwitch().isOn)
        XCTAssertTrue(TKSmileSwitch().isOn)
        XCTAssertTrue(TKLiquidSwitch().isOn)
    }

    func testSetOnWithSameValueIsNoOp() {
        let switcher = TKSimpleSwitch()
        switcher.setOn(true, animated: false)
        XCTAssertTrue(switcher.isOn)
        switcher.isOn = true
        XCTAssertTrue(switcher.isOn)
    }

    func testIntrinsicContentSize() {
        XCTAssertEqual(TKSimpleSwitch().intrinsicContentSize, CGSize(width: 80, height: 40))
    }

    // MARK: - Events

    func testToggleReportsNewValueThroughClosure() {
        var received: [Bool] = []

        let switcher = TKSimpleSwitch()
        switcher.onValueChange = { received.append($0) }

        switcher.toggleValue()

        XCTAssertEqual(received, [false], "onValueChange should report the new value")
        XCTAssertFalse(switcher.isOn)
    }

    func testSetOnDoesNotFireEvents() {
        var received: [Bool] = []

        let switcher = TKSimpleSwitch()
        switcher.onValueChange = { received.append($0) }

        switcher.setOn(false, animated: false)

        XCTAssertEqual(received, [], "setOn should not call onValueChange")
        XCTAssertFalse(switcher.isOn)
    }
}
