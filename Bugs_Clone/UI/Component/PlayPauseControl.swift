//
//  PlayPauseControl.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine

final class PlayPauseControl: UIControl, MusicControl {
    @Published private(set) var didTap: Status?

    enum Status {
        case play
        case pause

        var image: UIImage? {
            switch self {
            case .play:
                return UIImage(systemName: "pause")
            case .pause:
                return UIImage(systemName: "play")
            }
        }
    }

    private lazy var imageView = UIImageView()
    private(set) var status: Status = .pause {
        didSet {
            setNeedsLayout()
        }
    }
    private var previousStatus: Status?

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

    func rollbackStatus() {
        guard let previousStatus = previousStatus else { return }

        status = previousStatus
        self.previousStatus = nil
    }
}

private extension PlayPauseControl {
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

    func toggleStatus() {
        switch status {
        case .play:
            previousStatus = status
            status = .pause
        case .pause:
            previousStatus = status
            status = .play
        }
    }

    func runScaleEffect() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut], animations: {
            self.imageView.transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        }, completion: { _ in
            self.imageView.transform = .identity
        })
    }
}
