//
//  PlayPauseControl.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine
import MusicPlayerCommon

final class PlayPauseControl: UIControl, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> { tapSubject.eraseToAnyPublisher() }

    private(set) var mode: PlayPauseMode = .pause {
        didSet {
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
        case .play:
            self.mode = .pause
        case .pause:
            self.mode = .play
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
        tapSubject.send(())
    }
}

// MARK: - Const

private extension PlayPauseControl {
    enum Const {
        static func image(mode: PlayPauseMode) -> UIImage? {
            switch mode {
            case .play:
                return UIImage(systemName: "pause")
            case .pause:
                return UIImage(systemName: "play")
            }
        }
    }
}
