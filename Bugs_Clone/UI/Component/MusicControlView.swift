//
//  MusicControlView.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine

final class MusicControlView: UIView {
    @Published private(set) var repeatControlDidTap: RepeatControl.Status?
    @Published private(set) var precedentControlDidTap: Void?
    @Published private(set) var playPauseControlDidTap: PlayPauseControl.Status?
    @Published private(set) var subsequentControlDidTap: Void?
    @Published private(set) var shuffleControlDidTap: ShuffleControl.Status?

    enum Command {
        case `repeat`
        case precedent
        case playPause
        case subsequent
        case shuffle
    }

    private(set) lazy var repeatControl = RepeatControl()
    private(set) lazy var precedentControl = PrecedentControl()
    private(set) lazy var playPauseControl = PlayPauseControl()
    private(set) lazy var subsequentControl = SubsequentControl()
    private(set) lazy var shuffleControl = ShuffleControl()

    private lazy var stackView = UIStackView(arrangedSubviews: [repeatControl, precedentControl, playPauseControl, subsequentControl, shuffleControl])

    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Method

private extension MusicControlView {
    func configureViews() {
        stackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width / 10)
                $0.height.equalTo(UIScreen.main.bounds.width / 10)
            }
        }
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        repeatControl.do {
            $0.addTarget(self, action: #selector(repeatControlDidTap(_:)), for: .touchUpInside)
            $0.$didTap
                .assign(to: \.repeatControlDidTap, on: self)
                .store(in: &cancellables)
        }

        precedentControl.do {
            $0.addTarget(self, action: #selector(precedentControlDidTap(_:)), for: .touchUpInside)
            $0.$didTap
                .assign(to: \.precedentControlDidTap, on: self)
                .store(in: &cancellables)
        }

        playPauseControl.do {
            $0.addTarget(self, action: #selector(playPauseControlDidTap(_:)), for: .touchUpInside)
            $0.$didTap
                .assign(to: \.playPauseControlDidTap, on: self)
                .store(in: &cancellables)
        }

        subsequentControl.do {
            $0.addTarget(self, action: #selector(subsequentControlDidTap(_:)), for: .touchUpInside)
            $0.$didTap
                .assign(to: \.subsequentControlDidTap, on: self)
                .store(in: &cancellables)
        }

        shuffleControl.do {
            $0.addTarget(self, action: #selector(shuffleControlDidTap(_:)), for: .touchUpInside)
            $0.$didTap
                .assign(to: \.shuffleControlDidTap, on: self)
                .store(in: &cancellables)
        }
    }
}

private extension MusicControlView {
    @objc func repeatControlDidTap(_ sender: UIControl) {
        repeatControl.run()
    }

    @objc func precedentControlDidTap(_ sender: UIControl) {
        precedentControl.run()
    }

    @objc func playPauseControlDidTap(_ sender: UIControl) {
        playPauseControl.run()
    }

    @objc func subsequentControlDidTap(_ sender: UIControl) {
        subsequentControl.run()
    }

    @objc func shuffleControlDidTap(_ sender: UIControl) {
        shuffleControl.run()
    }
}
