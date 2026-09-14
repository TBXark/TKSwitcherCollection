//
//  UIKitDemoViewController.swift
//  TKSwitcherCollectionDemo
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015 TBXark. All rights reserved.
//

import TKSwitcherCollection
import UIKit

final class UIKitDemoViewController: UIViewController {

    private var switchers: [TKBaseSwitch] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "TKSwitcherCollection"

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let rows: [(String, TKBaseSwitch)] = [
            ("TKSimpleSwitch", TKSimpleSwitch()),
            (
                "TKSimpleSwitch Rotate",
                configure(TKSimpleSwitch()) { $0.rotateWhenValueChange = true }
            ),
            ("TKSimpleSwitch Off", configure(TKSimpleSwitch()) { $0.isOn = false }),
            (
                "TKSimpleSwitch Custom",
                configure(TKSimpleSwitch()) {
                    $0.onColor = .systemIndigo
                    $0.lineColor = .systemIndigo.withAlphaComponent(0.4)
                }
            ),
            ("TKExchangeSwitch", TKExchangeSwitch()),
            (
                "TKExchangeSwitch Custom",
                configure(TKExchangeSwitch()) {
                    $0.onColor = .systemOrange
                    $0.offColor = .systemBlue
                }
            ),
            ("TKSmileSwitch", TKSmileSwitch()),
            ("TKLiquidSwitch", TKLiquidSwitch()),
            (
                "TKLiquidSwitch Custom",
                configure(TKLiquidSwitch()) {
                    $0.onColor = .systemPink
                    $0.offColor = .systemGray4
                }
            ),
        ]

        for (title, switcher) in rows {
            stackView.addArrangedSubview(makeRow(title: title, switcher: switcher))
        }

        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("Toggle All", for: .normal)
        toggleButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        toggleButton.addTarget(self, action: #selector(toggleAll), for: .touchUpInside)
        stackView.addArrangedSubview(toggleButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }

    private func makeRow(title: String, switcher: TKBaseSwitch) -> UIView {
        switchers.append(switcher)
        switcher.onValueChange = { value in
            print("\(title) -> \(value)")
        }
        switcher.widthAnchor.constraint(equalToConstant: 100).isActive = true
        switcher.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .callout)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [titleLabel, switcher])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 16
        return row
    }

    private func configure<T: TKBaseSwitch>(_ switcher: T, _ configure: (T) -> Void) -> T {
        configure(switcher)
        return switcher
    }

    @objc private func toggleAll() {
        for (index, switcher) in switchers.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.12) {
                [weak switcher] in
                guard let switcher else { return }
                switcher.setOn(!switcher.isOn, animated: true)
            }
        }
    }
}
