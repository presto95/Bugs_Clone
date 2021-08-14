//
//  RepeatControl.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import UIKit

final class RepeatControl: UIControl {
    enum Status: String {
        case off
        case one
    }

    @Published private(set) var tap: Void?
    @Published var status: Status = .off {
        didSet {
            UserDefaults.standard.lastRepeatStatus = status
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

extension RepeatControl: MusicControl {
    func setNextStatus(animated: Bool) {
        switch status {
        case .off:
            self.status = .one
        case .one:
            self.status = .off
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
            $0.image = Const.image(status: status)
        }

        subviews {
            imageView
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateViews() {
        imageView.image = Const.image(status: status)
    }

    @objc func viewDidTap(_ sender: UIControl) {
        tap = ()
    }
}

// MARK: - Const

private extension RepeatControl {
    enum Const {
        static func image(status: Status) -> UIImage? {
            switch status {
            case .off:
                return UIImage(systemName: "repeat")
            case .one:
                return UIImage(systemName: "repeat.1")
            }
        }
    }
}
