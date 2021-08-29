//
//  ShuffleControl.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine
import MusicPlayerCommon
import Common

final class ShuffleControl: UIControl, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> { tapSubject.eraseToAnyPublisher() }

    private(set) var mode: ShuffleMode = .off {
        didSet {
            UserDefaults.standard.lastShuffleMode = mode
            setNeedsLayout()
        }
    }

    private lazy var imageView = UIImageView()

    private var tapSubject = CurrentValueSubject<Void?, Never>(nil)

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

    // MARK: MusicControlComponentProtocol

    func setNextMode(animated: Bool) {
        switch mode {
        case .off:
            self.mode = .on
        case .on:
            self.mode = .off
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
        self.alpha = Const.alpha(mode: mode)
    }

    @objc func viewDidTap(_ sender: UIControl) {
        tapSubject.send(())
    }
}

// MARK: - Const

private extension ShuffleControl {
    enum Const {
        static func alpha(mode: ShuffleMode) -> CGFloat {
            switch mode {
            case .off:
                return 0.4
            case .on:
                return 1
            }
        }
    }
}
