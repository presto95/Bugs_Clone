//
//  MusicPlayerTopView.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/24.
//

import UIKit
import Combine
import MusicPlayerCommon
import Common

final class MusicPlayerTopView: UIView {
    private var albumCoverView: MusicPlayerAlbumCoverView!
    private(set) var lyricsView: MusicPlayerLyricsView!

    private var musicPlayerRootUIInteractor: MusicPlayerRootUIInteractable? {
        return DIContainer.shared.resolve(MusicPlayerRootUIInteractable.self)
    }

    private var viewModel: MusicPlayerTopViewModel

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MusicPlayerTopViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureViews()
        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Method

private extension MusicPlayerTopView {
    func configureViews() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap(_:)))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)

        let albumCoverViewModel = MusicPlayerAlbumCoverViewModel()
        albumCoverView = MusicPlayerAlbumCoverView(viewModel: albumCoverViewModel)
        viewModel.albumCoverViewModel = albumCoverViewModel
        albumCoverView.do {
            $0.alpha = 1
        }

        let lyricsViewModel = MusicPlayerLyricsViewModel()
        lyricsView = MusicPlayerLyricsView(viewModel: lyricsViewModel)
        viewModel.lyricsViewModel = lyricsViewModel
        lyricsView.do {
            $0.alpha = 0
        }

        subviews {
            albumCoverView
            lyricsView
        }

        albumCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        lyricsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bindViewModel() {
        viewModel.$displayingInfo
            .filter { $0 == .albumCover }
            .sink { [weak self] _ in
                self?.musicPlayerRootUIInteractor?.adjustRootViews(by: .albumCover)

                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                                self?.albumCoverView.alpha = 1
                                self?.lyricsView.alpha = 0
                               },
                               completion: nil)
            }
            .store(in: &cancellables)

        viewModel.$displayingInfo
            .filter { $0 == .lyric }
            .sink { [weak self] _ in
                self?.musicPlayerRootUIInteractor?.adjustRootViews(by: .lyric)
                self?.lyricsView.updateSelectedLyricAlignmentToCenterY()

                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                                self?.albumCoverView.alpha = 0
                                self?.lyricsView.alpha = 1
                               },
                               completion: nil)
            }
            .store(in: &cancellables)
    }

    @objc func viewDidTap(_ recognizer: UITapGestureRecognizer) {
        viewModel.setNextDisplayingInfo()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension MusicPlayerTopView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewModel.displayingInfo == .lyric else { return true }

        let touchedPoint = gestureRecognizer.location(in: self)
        let visibleCells = lyricsView.visibleLyricCells
        for cell in visibleCells {
            if let textLabel = cell.textLabel {
                let textLabelFrame = textLabel.bounds
                let convertedFrame = textLabel.convert(textLabelFrame, to: self)
                if convertedFrame.contains(touchedPoint) {
                    return false
                }
            }
        }

        return true
    }
}
