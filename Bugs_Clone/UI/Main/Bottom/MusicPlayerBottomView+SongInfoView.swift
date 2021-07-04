//
//  MusicPlayerBottomView+SongInfoView.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/25.
//

import UIKit

extension MusicPlayerBottomView {
    final class SongInfoView: UIView {
        private lazy var titleLabel = UILabel()
        private lazy var albumLabel = UILabel()
        private lazy var artistLabel = UILabel()

        var title: String? {
            get {
                return titleLabel.text
            }
            set {
                titleLabel.text = newValue
            }
        }

        var album: String? {
            get {
                return albumLabel.text
            }
            set {
                albumLabel.text = newValue
            }
        }

        var artist: String? {
            get {
                return artistLabel.text
            }
            set {
                artistLabel.text = newValue
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            configureViews()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

private extension MusicPlayerBottomView.SongInfoView {
    func configureViews() {
        titleLabel.do {
            $0.font = .preferredFont(forTextStyle: .headline)
            $0.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        }

        albumLabel.do {
            $0.font = .preferredFont(forTextStyle: .footnote)
            $0.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        }

        artistLabel.do {
            $0.font = .preferredFont(forTextStyle: .footnote)
        }

        addSubviews {
            titleLabel
            albumLabel
            artistLabel
        }

        titleLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        albumLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Const.spacingBetweenTitleAndAlbum)
            make.centerX.equalToSuperview()
        }

        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(albumLabel.snp.bottom).offset(Const.spacingBetweenAlbumAndArtist)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

private extension MusicPlayerBottomView.SongInfoView{
    enum Const {
        static let spacingBetweenTitleAndAlbum: CGFloat = 16
        static let spacingBetweenAlbumAndArtist: CGFloat = 8
    }
}
