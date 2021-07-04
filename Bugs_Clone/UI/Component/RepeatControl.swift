//
//  RepeatControl.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import UIKit

final class RepeatControl: UIControl, MusicControl {
    @Published private(set) var didTap: Status?

    enum Status {
        case off
        case one

        var image: UIImage? {
            switch self {
            case .off:
                return UIImage(systemName: "repeat")
            case .one:
                return UIImage(systemName: "repeat.1")
            }
        }
    }

    private lazy var imageView = UIImageView()
    private(set) var status: Status = .off {
        didSet {
            setNeedsLayout()
        }
    }

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

    func run() {
        toggleStatus()
        runScaleEffect()
        didTap = status
    }
}

private extension RepeatControl {
    func toggleStatus() {
        switch status {
        case .off:
            status = .one
        case .one:
            status = .off
        }
    }
}

// MARK: - UI

private extension RepeatControl {
    func configureViews() {
        imageView.do {
            $0.image = status.image
        }

        addSubviews {
            imageView
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateViews() {
        imageView.image = status.image
    }

    func runScaleEffect() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut], animations: {
            self.imageView.transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        }, completion: { _ in
            self.imageView.transform = .identity
        })
    }
}
