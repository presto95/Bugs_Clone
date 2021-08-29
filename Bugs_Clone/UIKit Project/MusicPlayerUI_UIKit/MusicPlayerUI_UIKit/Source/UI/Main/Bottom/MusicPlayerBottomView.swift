//
//  MusicPlayerBottomView.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/24.
//

import UIKit
import Combine
import MusicPlayerCommon
import Common

final class MusicPlayerBottomView: UIView {
    private(set) lazy var seekbar = Seekbar()
    private lazy var currentTimeLabel = UILabel()
    private lazy var endTimeLabel = UILabel()
    private lazy var songInfoViewContainerView = UIView()
    private lazy var musicControlViewContainerView = UIView()
    private lazy var songInfoView = MusicPlayerSongInfoView()
    private(set) lazy var musicControlView = MusicControlView()

    private var navigationInteractor: NavigationInteractable? {
        return DIContainer.shared.resolve(NavigationInteractable.self)
    }

    private var musicInteractor: MusicInteractable? {
        return DIContainer.shared.resolve(MusicInteractable.self)
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
            $0.textColor = .label
            $0.font = .preferredFont(forTextStyle: .footnote)
        }

        endTimeLabel.do {
            $0.textColor = .label
            $0.font = .preferredFont(forTextStyle: .footnote)
        }

        songInfoView.do {
            $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }

        subviews {
            seekbar
            currentTimeLabel
            endTimeLabel
            songInfoViewContainerView.subviews {
                songInfoView
            }
            musicControlViewContainerView.subviews {
                musicControlView
            }
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

        songInfoViewContainerView.snp.makeConstraints { make in
            make.top.equalTo(currentTimeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(musicControlViewContainerView)
        }

        musicControlViewContainerView.snp.makeConstraints { make in
            make.top.equalTo(songInfoViewContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        songInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
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
        seekbar.updatedTimeWithSeeking
            .sink { [weak self] currentTime in
                self?.musicInteractor?.updateMusicCurrentTime(currentTime)
                self?.musicInteractor?.updateCurrentTime(currentTime)
            }
            .store(in: &cancellables)

        musicControlView.repeatControl.tap
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.musicControlView.repeatControl.setNextMode(animated: true)
            }
            .store(in: &cancellables)

        musicControlView.precedentControl.tap
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.musicControlView.precedentControl.setNextMode(animated: true)
            }
            .store(in: &cancellables)

        musicControlView.playPauseControl.do {
            $0.tap
                .compactMap { $0 }
                .sink { [weak self] _ in
                    let mode = self?.musicControlView.playPauseControl.mode
                    switch mode {
                    case .play:
                        do {
                            try self?.musicInteractor?.pauseMusic()
                            self?.musicControlView.playPauseControl.setNextMode(animated: true)
                        } catch {
                            self?.navigationInteractor?.presentAlert(withMessage: "RETRY")
                        }
                    case .pause:
                        do {
                            try self?.musicInteractor?.playMusic()
                            self?.musicControlView.playPauseControl.setNextMode(animated: true)
                        } catch {
                            self?.navigationInteractor?.presentAlert(withMessage: "RETRY")
                        }
                    case .none:
                        break
                    }
                }
                .store(in: &cancellables)
        }

        musicControlView.subsequentControl.tap
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.musicControlView.subsequentControl.setNextMode(animated: true)
            }
            .store(in: &cancellables)

        musicControlView.shuffleControl.tap
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.musicControlView.shuffleControl.setNextMode(animated: true)
            }
            .store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.$title
            .assign(to: \.title, on: songInfoView)
            .store(in: &cancellables)

        viewModel.$album
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
