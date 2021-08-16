//
//  PlayPauseControl.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine

final class PlayPauseControl: UIControl {
    enum Status: String {
        case play
        case pause
    }

    @Published private(set) var tap: Void?
    @Published var status: Status = .pause {
        didSet {
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

extension PlayPauseControl: MusicControl {
    func setNextStatus(animated: Bool) {
        switch status {
        case .play:
            self.status = .pause
        case .pause:
            self.status = .play
        }

        if animated {
            runScaleAnimation(to: imageView)
        }
    }
}

// MARK: - UI

private extension PlayPauseControl {
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

    func runScaleEffect() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.autoreverse, .curveEaseInOut],
                       animations: {
                        self.imageView.transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
                       },
                       completion: { _ in
                        self.imageView.transform = .identity
                       })
    }

    @objc func viewDidTap(_ sender: UIControl) {
        tap = ()
    }
}

// MARK: - Const

private extension PlayPauseControl {
    enum Const {
        static func image(status: Status) -> UIImage? {
            switch status {
            case .play:
                return UIImage(systemName: "pause")
            case .pause:
                return UIImage(systemName: "play")
            }
        }
    }
}
