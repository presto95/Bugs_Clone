//
//  ShuffleControl.swift
//  UIKitApp
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Common

final class ShuffleControl: UIControl {
    enum Status: String {
        case off
        case on
    }

    @Published private(set) var tap: Void?
    @Published var status: Status = .off {
        didSet {
            UserDefaults.standard.lastShuffleStatus = status
            setNeedsLayout()
        }
    }

    private lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateViews()
    }
}

// MARK: - MusicControl

extension ShuffleControl: MusicControl {
    func setNextStatus(animated: Bool) {
        switch status {
        case .off:
            self.status = .on
        case .on:
            self.status = .off
        }

        if animated {
            runScaleAnimation(to: imageView)
        }
    }
}

// MARK: - Private Method

private extension ShuffleControl {
    func configureViews() {
        addTarget(self, action: #selector(viewDidTap(_:)), for: .touchUpInside)

        imageView.do {
            $0.image = UIImage(systemName: "shuffle")
        }

        subviews {
            imageView
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateViews() {
        self.alpha = Const.alpha(status: status)
    }

    @objc func viewDidTap(_ sender: UIControl) {
        tap = ()
    }
}

// MARK: - Const

private extension ShuffleControl {
    enum Const {
        static func alpha(status: Status) -> CGFloat {
            switch status {
            case .off:
                return 0.4
            case .on:
                return 1
            }
        }
    }
}
