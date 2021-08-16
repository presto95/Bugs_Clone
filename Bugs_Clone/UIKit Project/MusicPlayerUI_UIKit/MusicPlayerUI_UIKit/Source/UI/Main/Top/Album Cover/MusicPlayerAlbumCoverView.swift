//
//  MusicPlayerAlbumCoverView.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/08/16.
//

import UIKit
import Combine
import MusicPlayerCommon

final class MusicPlayerAlbumCoverView: UIView {
    private lazy var imageView = UIImageView()

    private var viewModel: MusicPlayerAlbumCoverViewModel

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MusicPlayerAlbumCoverViewModel) {
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

private extension MusicPlayerAlbumCoverView {
    func configureViews() {
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }

        subviews {
            imageView
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bindViewModel() {
        viewModel.$albumCoverImageData
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .compactMap(UIImage.init)
            .assign(to: \.image, on: imageView)
            .store(in: &cancellables)
    }
}
