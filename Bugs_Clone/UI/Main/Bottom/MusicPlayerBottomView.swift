//
//  MusicPlayerBottomView.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/24.
//

import UIKit
import Combine

final class MusicPlayerBottomView: UIView {
    private(set) lazy var seekbar = Seekbar()
    private lazy var currentTimeLabel = UILabel()
    private lazy var endTimeLabel = UILabel()
    private lazy var songInfoViewBackgroundView = UIView()
    private lazy var musicControlViewBackgroundView = UIView()
    private lazy var songInfoView = SongInfoView()
    private lazy var musicControlView = MusicControlView()

    private var navigationInteractor: NavigationInteractable? {
        return DIContainer.shared.resolve(NavigationInteractable.self)
    }

    private var audioInteractor: AudioInteractable? {
        return DIContainer.shared.resolve(AudioInteractable.self)
    }

    private var viewModel: MusicPlayerBottomViewModel

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MusicPlayerBottomViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureViews()
        bindSubviews()
        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicPlayerBottomView {
    func updateCurrentTime(_ currentTime: TimeInterval) {
        viewModel.setCurrentTime(currentTime)
    }
}

private extension MusicPlayerBottomView {
    func configureViews() {
        currentTimeLabel.do {
            $0.textColor = .lightGray
            $0.font = .preferredFont(forTextStyle: .footnote)
        }

        endTimeLabel.do {
            $0.textColor = .lightGray
            $0.font = .preferredFont(forTextStyle: .footnote)
        }

        songInfoView.do {
            $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }

        addSubviews {
            seekbar
            currentTimeLabel
            endTimeLabel
            songInfoViewBackgroundView
            musicControlViewBackgroundView
        }

        songInfoViewBackgroundView.addSubviews {
            songInfoView
        }

        musicControlViewBackgroundView.addSubviews {
            musicControlView
        }

        seekbar.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(seekbar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }

        endTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(seekbar.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }

        songInfoViewBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.leading.trailing.equalToSuperview()
        }

        musicControlViewBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(songInfoViewBackgroundView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }

        songInfoView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(-16)
        }

        musicControlView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func bindSubviews() {
        seekbar.$trackingDidEndWithUpdatedTime
            .sink { [weak self] currentTime in
                self?.audioInteractor?.updateAudioCurrentTime(currentTime)
                self?.audioInteractor?.updateCurrentTime(currentTime)
            }
            .store(in: &cancellables)

        musicControlView.do {
            $0.$repeatControlDidTap
                .compactMap { $0 }
                .sink { _ in
                    Logger.log("Repeat Control didTap")
                }
                .store(in: &cancellables)

            $0.$precedentControlDidTap
                .compactMap { $0 }
                .sink { _ in
                    Logger.log("Precedent Control didTap")
                }
                .store(in: &cancellables)

            $0.$playPauseControlDidTap
                .compactMap { $0 }
                .filter { $0 == .play }
                .sink { [weak self] _ in
                    let result = self?.audioInteractor?.playAudio()
                    if result == false {
                        self?.musicControlView.playPauseControl.rollbackStatus()
                        self?.navigationInteractor?.presentAlert(withMessage: "RETRY")
                    }
                }
                .store(in: &cancellables)

            $0.$playPauseControlDidTap
                .compactMap { $0 }
                .filter { $0 == .pause }
                .sink { [weak self] _ in
                    let result = self?.audioInteractor?.pauseAudio()
                    if result == false {
                        self?.musicControlView.playPauseControl.rollbackStatus()
                        self?.navigationInteractor?.presentAlert(withMessage: "RETRY")
                    }
                }
                .store(in: &cancellables)

            $0.$subsequentControlDidTap
                .compactMap { $0 }
                .sink { _ in
                    Logger.log("Subsequent Control didTap")
                }
                .store(in: &cancellables)

            $0.$shuffleControlDidTap
                .compactMap { $0 }
                .sink { _ in
                    Logger.log("Shuffle Control didTap")
                }
                .store(in: &cancellables)
        }
    }

    func bindViewModel() {
        viewModel.$title
            .assign(to: \.title, on: songInfoView)
            .store(in: &cancellables)

        viewModel.$albumName
            .assign(to: \.album, on: songInfoView)
            .store(in: &cancellables)

        viewModel.$artist
            .assign(to: \.artist, on: songInfoView)
            .store(in: &cancellables)

        viewModel.$currentTime
            .assign(to: \.text, on: currentTimeLabel)
            .store(in: &cancellables)

        viewModel.$endTime
            .assign(to: \.text, on: endTimeLabel)
            .store(in: &cancellables)
    }
}
