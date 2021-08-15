//
//  Seekbar.swift
//  UIKitMusicPlayer
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine

protocol SeekbarProtocol: AnyObject {
    var currentTime: TimeInterval { get set }
    var endTime: TimeInterval { get set }
}

final class Seekbar: UIView, SeekbarProtocol {
    @Published private(set) var updatedTimeWithSeeking: TimeInterval = 0

    private lazy var entireTimeBar = UIView()
    private lazy var currentTimeBar = UIView()

    var currentTime: TimeInterval {
        get {
            return _currentTime
        }
        set {
            _currentTime = newValue

            if isTracking == false {
                let timeRatio: TimeInterval = {
                    if endTime == 0 {
                        return 0
                    } else {
                        return currentTime / endTime
                    }
                }()
                currentTimeBar.snp.updateConstraints { make in
                    make.trailing.equalToSuperview().offset(-Const.width + Const.width * CGFloat(timeRatio))
                }
            }
        }
    }

    var endTime: TimeInterval {
        get {
            return _endTime
        }
        set {
            _endTime = newValue
        }
    }

    var normalStatusHeight: CGFloat! {
        get {
            return _normalStatusHeight ?? Const.minimumNormalStatusHeight
        }
        set {
            _normalStatusHeight = max(newValue ?? 2, Const.minimumNormalStatusHeight)
            setNeedsUpdateConstraints()
        }
    }

    var trackingStatusHeight: CGFloat! {
        get {
            return _trackingStatusHeight ?? Const.minimumInteractiveStatusHeight
        }
        set {
            _trackingStatusHeight = max(newValue ?? 8, Const.minimumInteractiveStatusHeight)
            setNeedsUpdateConstraints()
        }
    }

    private var _currentTime: TimeInterval = 0
    private var _endTime: TimeInterval = 0
    private var _normalStatusHeight: CGFloat? = Const.minimumNormalStatusHeight
    private var _trackingStatusHeight: CGFloat? = Const.minimumInteractiveStatusHeight
    private var isTracking: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        entireTimeBar.snp.updateConstraints { make in
            make.height.equalTo(normalStatusHeight)
        }

        currentTimeBar.snp.updateConstraints { make in
            make.height.equalTo(normalStatusHeight)
        }

        super.updateConstraints()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: Const.width, height: trackingStatusHeight)
    }
}

private extension Seekbar {
    func configureViews() {
        self.do {
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap(_:))))
            $0.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(backgroundViewDidPan(_:))))
            $0.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(backgroundViewDidLongPress(_:))).then {
                $0.minimumPressDuration = 0.1
            })
        }

        entireTimeBar.do {
            $0.backgroundColor = .systemGray
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(entireTimeBarDidTap(_:))))
            $0.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(entireTimeBarDidPan(_:))))
            $0.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(entireTimeBarDidLongPress(_:))).then {
                $0.minimumPressDuration = 0.1
            })
        }

        currentTimeBar.do {
            $0.backgroundColor = .label
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currentTimeBarDidTap(_:))))
            $0.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(currentTimeBarDidPan(_:))))
            $0.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(currentTimeBarDidLongPress(_:))).then {
                $0.minimumPressDuration = 0.1
            })
        }

        subviews {
            entireTimeBar
            currentTimeBar
        }

        entireTimeBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(normalStatusHeight)
        }

        currentTimeBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Const.width)
            make.height.equalTo(normalStatusHeight)
        }
    }
}

// MARK: - Interaction

private extension Seekbar {
    @objc func backgroundViewDidTap(_ recognizer: UITapGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func backgroundViewDidPan(_ recognizer: UIPanGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func backgroundViewDidLongPress(_ recognizer: UILongPressGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func entireTimeBarDidTap(_ recognizer: UITapGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func entireTimeBarDidPan(_ recognizer: UIPanGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func entireTimeBarDidLongPress(_ recognizer: UILongPressGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func currentTimeBarDidTap(_ recognizer: UITapGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func currentTimeBarDidPan(_ recognizer: UIPanGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    @objc func currentTimeBarDidLongPress(_ recognizer: UILongPressGestureRecognizer) {
        updateCurrentTimeBar(with: recognizer)
    }

    func updateCurrentTimeBar(with recognizer: UIGestureRecognizer) {
        let interactionProgress = recognizer.location(in: entireTimeBar).x

        switch recognizer.state {
        case .began, .changed:
            isTracking = true

            do {
                currentTimeBar.snp.updateConstraints { make in
                    make.height.equalTo(trackingStatusHeight)
                }

                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                }
            }

            do {
                currentTimeBar.snp.updateConstraints { make in
                    make.trailing.equalToSuperview().offset(-Const.width + interactionProgress)
                }
            }
        case .ended:
            isTracking = false

            do {
                currentTimeBar.snp.updateConstraints { make in
                    make.height.equalTo(normalStatusHeight)
                }

                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                }
            }

            do {
                currentTimeBar.snp.updateConstraints { make in
                    make.trailing.equalToSuperview().offset(-Const.width + interactionProgress)
                }
            }

            let progress = TimeInterval(interactionProgress)
            let updatingTime: TimeInterval = {
                if progress == 0 {
                    return 0
                } else {
                    return progress * endTime / TimeInterval(Const.width)
                }
            }()
            updatedTimeWithSeeking = updatingTime
        default:
            break
        }
    }
}

// MARK: - Const

private extension Seekbar {
    enum Const {
        static let minimumNormalStatusHeight: CGFloat = 2
        static let minimumInteractiveStatusHeight: CGFloat = 8
        static let width = UIScreen.main.bounds.width
    }
}
