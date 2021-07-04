//
//  MusicPlayerViewController.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/02.
//

import UIKit
import Combine
import SnapKit

final class MusicPlayerViewController: UIViewController {
    private var topView: MusicPlayerTopView!
    private var bottomView: MusicPlayerBottomView!
    private lazy var backgroundImageView = UIImageView()
    private lazy var backgroundImageBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    private var viewModel: MusicPlayerViewModel

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MusicPlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
        registerDependencies()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestMusic()
    }
}

// MARK: - Private Method

private extension MusicPlayerViewController {
    func configureViews() {
        view.backgroundColor = .white

        let topViewModel = MusicPlayerTopViewModel()
        viewModel.topViewModel = topViewModel
        topView = MusicPlayerTopView(viewModel: topViewModel)

        let bottomViewModel = MusicPlayerBottomViewModel()
        viewModel.bottomViewModel = bottomViewModel
        bottomView = MusicPlayerBottomView(viewModel: bottomViewModel)

        backgroundImageView.do {
            $0.contentMode = .scaleAspectFill
        }

        view.addSubviews {
            backgroundImageView
            topView
            bottomView
        }

        backgroundImageView.addSubviews {
            backgroundImageBlurView
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
        DIContainer.shared.register(self, as: AudioInteractable.self)
    }
}

// MARK: - AudioInteractable

extension MusicPlayerViewController: AudioInteractable {
    var audioPlayer: AudioPlayerProtocol? {
        return viewModel.audioPlayer
    }

    var seekbar: SeekbarProtocol? {
        return bottomView.seekbar
    }

    var lyricsView: LyricsViewProtocol? {
        return topView.lyricView
    }

    func updateCurrentTime(_ currentTime: TimeInterval) {
        bottomView.updateCurrentTime(currentTime)
        seekbar?.currentTime = currentTime
        lyricsView?.selectLyricItem(before: currentTime)
    }

    func updateEndTime(_ endTime: TimeInterval) {
        seekbar?.endTime = endTime
    }

    func updateAudioCurrentTime(_ currentTime: TimeInterval) {
        audioPlayer?.currentTime = currentTime
    }

    @discardableResult
    func playAudio() -> Bool {
        guard let audioPlayer = audioPlayer else { return false }
        return audioPlayer.play()
    }

    @discardableResult
    func pauseAudio() -> Bool {
        guard let audioPlayer = audioPlayer else { return false }
        return audioPlayer.pause()
    }
}

// MARK: - NavigationDelegate

extension MusicPlayerViewController: NavigationInteractable {
    func presentAlert(withMessage message: String?) {
        UIAlertController
            .alert(title: "", message: message)
            .action(title: "OK", style: .default)
            .present(in: self, animated: true)
    }
}

// MARK: - MusicPlayerRootUIDelegate

extension MusicPlayerViewController: MusicPlayerRootUIInteractable {
    func adjustRootViews(by displayingInfo: DisplayingInfo) {
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
