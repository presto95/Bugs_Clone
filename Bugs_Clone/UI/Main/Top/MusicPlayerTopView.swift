//
//  MusicPlayerTopView.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/24.
//

import UIKit
import Combine

final class MusicPlayerTopView: UIView {
    private lazy var albumCoverImageView = UIImageView()
    private(set) var lyricView: MusicPlayerLyricView!

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

        albumCoverImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.alpha = 1
        }

        let lyricViewModel = MusicPlayerLyricViewModel()
        lyricView = MusicPlayerLyricView(viewModel: lyricViewModel)
        viewModel.lyricViewModel = lyricViewModel
        lyricView.do {
            $0.alpha = 0
        }

        subviews {
            albumCoverImageView
            lyricView
        }

        albumCoverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        lyricView.snp.makeConstraints { make in
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
                                self?.albumCoverImageView.alpha = 1
                                self?.lyricView.alpha = 0
                               },
                               completion: nil)
            }
            .store(in: &cancellables)

        viewModel.$displayingInfo
            .filter { $0 == .lyric }
            .sink { [weak self] _ in
                self?.musicPlayerRootUIInteractor?.adjustRootViews(by: .lyric)
                self?.lyricView.updateSelectedLyricAlignmentToCenterY()

                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                                self?.albumCoverImageView.alpha = 0
                                self?.lyricView.alpha = 1
                               },
                               completion: nil)
            }
            .store(in: &cancellables)

        viewModel.$albumCoverImageData
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .compactMap(UIImage.init)
            .assign(to: \.image, on: albumCoverImageView)
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
        let visibleCells = lyricView.visibleLyricCells
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
