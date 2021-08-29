//
//  MusicPlayerViewController.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/02.
//

import UIKit
import Combine
import SnapKit
import MusicPlayerCommon
import Walkman
import Common

public final class MusicPlayerViewController: UIViewController {
    private lazy var topView = MusicPlayerTopView(viewModel: viewModel.topViewModel)
    private lazy var bottomView = MusicPlayerBottomView(viewModel: viewModel.bottomViewModel)
    private lazy var backgroundImageView = UIImageView()
    private lazy var backgroundImageBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    private var viewModel: MusicPlayerViewModel

    private var cancellables = Set<AnyCancellable>()

    public init(viewModel: MusicPlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
        registerDependencies()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestMusic()
    }
}

// MARK: - Private Method

private extension MusicPlayerViewController {
    func configureViews() {
        view.backgroundColor = .white
        
        backgroundImageView.do {
            $0.contentMode = .scaleAspectFill
        }

        view.subviews {
            backgroundImageView.subviews {
                backgroundImageBlurView
            }
            topView
            bottomView
        }

        backgroundImageBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func bindViewModel() {
        viewModel.$albumCoverImageData
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .compactMap(UIImage.init)
            .assign(to: \.image, on: backgroundImageView)
            .store(in: &cancellables)
    }

    func registerDependencies() {
        DIContainer.shared.register(self, as: NavigationInteractable.self)
        DIContainer.shared.register(self, as: MusicPlayerRootUIInteractable.self)
        DIContainer.shared.register(self, as: MusicInteractable.self)
    }
}

// MARK: - MusicInteractable

extension MusicPlayerViewController: MusicInteractable {
    public var musicPlayerController: MusicPlayerController? {
        return viewModel.musicPlayer
    }

    public var seekingController: SeekingController? {
        return bottomView.seekbar
    }

    public var lyricsController: LyricsController? {
        return topView.lyricsView
    }

    public var musicControlController: MusicControlController? {
        return bottomView.musicControlView
    }

    public func updateCurrentTime(_ currentTime: TimeInterval) {
        bottomView.updateCurrentTime(currentTime)
        seekingController?.setCurrentTime(currentTime)
        lyricsController?.selectLyricItem(before: currentTime)
    }

    public func updateEndTime(_ endTime: TimeInterval) {
        seekingController?.setEndTime(endTime)
    }

    public func updateMusicCurrentTime(_ currentTime: TimeInterval) {
        musicPlayerController?.setCurrentTime(currentTime)
    }

    public func reset() {
        try? musicPlayerController?.stop()
        seekingController?.setCurrentTime(0)
        bottomView.updateCurrentTime(0)
        musicControlController?.setPlayPauseControlNextMode(animated: false)
        lyricsController?.unselectLyricItem()
    }

    public func playMusic() throws {
        guard let musicPlayer = musicPlayerController else { return }
        do {
            try musicPlayer.play()
        } catch {
            throw error
        }
    }

    public func pauseMusic() throws {
        guard let musicPlayer = musicPlayerController else { return }
        do {
            try musicPlayer.pause()
        } catch {
            throw error
        }
    }
}

// MARK: - NavigationDelegate

extension MusicPlayerViewController: NavigationInteractable {
    public func presentAlert(withMessage message: String?) {
        UIAlertController
            .alert(title: "", message: message)
            .action(title: "OK", style: .default)
            .present(in: self, animated: true)
    }
}

// MARK: - MusicPlayerRootUIDelegate

extension MusicPlayerViewController: MusicPlayerRootUIInteractable {
    public func adjustRootViews(by displayingInfo: DisplayingInfo) {
        switch displayingInfo {
        case .albumCover:
            topView.snp.updateConstraints { make in
                make.height.equalTo(UIScreen.main.bounds.width)
            }

            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.view.layoutIfNeeded()
                           },
                           completion: nil)
        case .lyric:
            topView.snp.updateConstraints { make in
                make.height.equalTo(UIScreen.main.bounds.height * 0.62)
            }

            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.view.layoutIfNeeded()
                           },
                           completion: nil)
        }
    }
}
