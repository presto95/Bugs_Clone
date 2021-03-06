//
//  RepeatControl.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine
import MusicPlayerCommon
import Common

final class RepeatControl: UIControl, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> { tapSubject.eraseToAnyPublisher() }

    private(set) var mode: RepeatMode = .off {
        didSet {
            UserDefaults.standard.lastRepeatMode = mode
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
            self.mode = .one
        case .one:
            self.mode = .off
        }

        if animated {
            runScaleAnimation(to: imageView)
        }
    }
}

// MARK: - UI

private extension RepeatControl {
    func configureViews() {
        addTarget(self, action: #selector(viewDidTap(_:)), for: .touchUpInside)

        imageView.do {
            $0.image = Const.image(mode: mode)
        }

        subviews {
            imageView
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateViews() {
        imageView.image = Const.image(mode: mode)
    }

    @objc func viewDidTap(_ sender: UIControl) {
        tapSubject.send(())
    }
}

// MARK: - Const

private extension RepeatControl {
    enum Const {
        static func image(mode: RepeatMode) -> UIImage? {
            switch mode {
            case .off:
                return UIImage(systemName: "repeat")
            case .one:
                return UIImage(systemName: "repeat.1")
            }
        }
    }
}
