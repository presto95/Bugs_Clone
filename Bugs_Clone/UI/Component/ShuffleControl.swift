//
//  ShuffleControl.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import UIKit

final class ShuffleControl: UIControl, MusicControl {
    @Published private(set) var didTap: Status?

    enum Status {
        case off
        case on

        var alpha: CGFloat {
            switch self {
            case .off:
                return 0.4
            case .on:
                return 1
            }
        }
    }

    var onClick: ((Status) -> Void)?

    private lazy var imageView = UIImageView()
    private var status: Status = .off {
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

private extension ShuffleControl {
    func toggleStatus() {
        switch status {
        case .off:
            status = .on
        case .on:
            status = .off
        }
    }
}

private extension ShuffleControl {
    func configureViews() {
        imageView.do {
            $0.image = UIImage(systemName: "shuffle")
        }

        addSubviews {
            imageView
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateViews() {

    }

    func runScaleEffect() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut], animations: {
            self.imageView.transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        }, completion: { _ in
            self.imageView.transform = .identity
        })
    }
}
