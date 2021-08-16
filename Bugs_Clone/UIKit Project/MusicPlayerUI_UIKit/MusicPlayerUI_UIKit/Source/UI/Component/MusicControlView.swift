//
//  MusicControlView.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine

final class MusicControlView: UIView {
    private(set) lazy var repeatControl = RepeatControl()
    private(set) lazy var precedentControl = PrecedentControl()
    private(set) lazy var playPauseControl = PlayPauseControl()
    private(set) lazy var subsequentControl = SubsequentControl()
    private(set) lazy var shuffleControl = ShuffleControl()
    private var stackView: UIStackView!

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
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .fill

        stackView.arrangedSubviews {
            repeatControl
            precedentControl
            playPauseControl
            subsequentControl
            shuffleControl
        }

        stackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width / 10)
                $0.height.equalTo(UIScreen.main.bounds.width / 10)
            }
        }

        subviews {
            stackView
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
