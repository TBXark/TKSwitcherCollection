//
//  SwitchRenderingTests.swift
//  TKSwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import UIKit
import XCTest

@testable import TKSwitcherCollection

/// Renders a switch's layer into a bitmap and samples single pixels,
/// so the tests assert what is actually drawn instead of stored properties.
private struct Pixel {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0

    init(_ color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        r = red
        g = green
        b = blue
    }

    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        r = red
        g = green
        b = blue
    }

    func distance(to other: Pixel) -> CGFloat {
        let dr = abs(r - other.r)
        let dg = abs(g - other.g)
        let db = abs(b - other.b)
        return max(dr, max(dg, db))
    }
}

extension Pixel: CustomStringConvertible {
    var description: String {
        "(\(r), \(g), \(b))"
    }
}

@MainActor
private func assertPixel(
    _ view: UIView, x: Int, y: Int, matches expected: UIColor, accuracy: CGFloat = 0.06,
    file: StaticString = #filePath, line: UInt = #line
) {
    assertPixel(
        view.layer, x: x, y: y, matches: expected, accuracy: accuracy, file: file, line: line)
}

@MainActor
private func assertPixel(
    _ layer: CALayer, x: Int, y: Int, matches expected: UIColor, accuracy: CGFloat = 0.06,
    file: StaticString = #filePath, line: UInt = #line
) {
    let scale: CGFloat = 2
    let width = Int(layer.bounds.width * scale)
    let height = Int(layer.bounds.height * scale)
    var pixels = [UInt8](repeating: 0, count: width * height * 4)
    guard
        let ctx = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
    else {
        XCTFail("Could not create bitmap context", file: file, line: line)
        return
    }
    ctx.scaleBy(x: scale, y: scale)
    layer.render(in: ctx)

    let row = Int(CGFloat(y) * scale)
    let column = Int(CGFloat(x) * scale)
    let index = (row * width + column) * 4
    let got = Pixel(
        red: CGFloat(pixels[index]) / 255.0,
        green: CGFloat(pixels[index + 1]) / 255.0,
        blue: CGFloat(pixels[index + 2]) / 255.0)
    let want = Pixel(expected)
    let distance = got.distance(to: want)
    XCTAssertLessThan(
        distance, accuracy, "color mismatch at (\(x), \(y)): got \(got), want \(want)", file: file,
        line: line)
}

@MainActor
final class SwitchRenderingTests: XCTestCase {

    private let testFrame = CGRect(x: 0, y: 0, width: 80, height: 40)
    private let simpleOnColor = UIColor(red: 0.341, green: 0.914, blue: 0.506, alpha: 1)
    private let simpleOffColor = UIColor(white: 0.9, alpha: 1)
    private let exchangeOnColor = UIColor(red: 0.34, green: 0.91, blue: 0.51, alpha: 1.00)
    private let exchangeOffColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
    private let liquidOnColor = UIColor(red: 0.373, green: 0.843, blue: 0.596, alpha: 1)
    private let liquidOffColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1)
    private let happyColor = UIColor(red: 0.388, green: 0.839, blue: 0.608, alpha: 1.000)
    private let sadColor = UIColor(red: 0.843, green: 0.369, blue: 0.373, alpha: 1)

    // issue #6: `isOn` must actually be reflected by the rendered view.

    func testSimpleSwitchRendersState() {
        // ON (default): fill is onColor, knob rests on the left
        let onSwitch = TKSimpleSwitch(frame: testFrame)
        XCTAssertTrue(onSwitch.isOn)
        assertPixel(onSwitch, x: 16, y: 20, matches: .white)
        assertPixel(onSwitch, x: 60, y: 20, matches: simpleOnColor)

        // Programmatically turning OFF updates the view: knob moves right, fill turns gray
        onSwitch.isOn = false
        assertPixel(onSwitch, x: 60, y: 20, matches: .white)
        assertPixel(onSwitch, x: 16, y: 20, matches: simpleOffColor)

        // A switch created in the OFF state renders OFF right away
        let offSwitch = TKSimpleSwitch(frame: testFrame)
        offSwitch.isOn = false
        assertPixel(offSwitch, x: 60, y: 20, matches: .white)
        assertPixel(offSwitch, x: 16, y: 20, matches: simpleOffColor)
    }

    func testSimpleSwitchCustomColors() {
        let switcher = TKSimpleSwitch(frame: testFrame)
        switcher.onColor = .red
        assertPixel(switcher, x: 60, y: 20, matches: .red)

        switcher.offColor = .blue
        switcher.isOn = false
        assertPixel(switcher, x: 16, y: 20, matches: .blue)
    }

    func testSimpleSwitchFrameChangeRebuilds() {
        let switcher = TKSimpleSwitch(frame: testFrame)
        switcher.isOn = false
        switcher.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        XCTAssertFalse(switcher.isOn)
        // Knob rests on the right after relayout
        assertPixel(switcher, x: 75, y: 25, matches: .white, accuracy: 0.08)
    }

    func testExchangeSwitchRendersState() {
        // ON (default): onColor knob on the left
        let switcher = TKExchangeSwitch(frame: testFrame)
        assertPixel(switcher, x: 20, y: 20, matches: exchangeOnColor)

        switcher.isOn = false
        assertPixel(switcher, x: 60, y: 20, matches: exchangeOffColor)
        assertPixel(switcher, x: 20, y: 20, matches: UIColor(white: 0.95, alpha: 1))
    }

    func testSmileSwitchRendersState() {
        let trackColor = UIColor(white: 0.9, alpha: 1)

        // ON (default): happy face on the left. Sample the cheek, away from mouth and eyes.
        let switcher = TKSmileSwitch(frame: testFrame)
        assertPixel(switcher, x: 9, y: 33, matches: happyColor)

        switcher.isOn = false
        assertPixel(switcher, x: 49, y: 33, matches: sadColor)
        // The track is a stroked ring; sample its bottom edge
        assertPixel(switcher, x: 40, y: 36, matches: trackColor)
    }

    func testLiquidSwitchRendersState() {
        // ON (default): green
        let switcher = TKLiquidSwitch(frame: testFrame)
        assertPixel(switcher, x: 8, y: 20, matches: liquidOnColor)

        switcher.isOn = false
        assertPixel(switcher, x: 8, y: 20, matches: liquidOffColor)
    }
}
