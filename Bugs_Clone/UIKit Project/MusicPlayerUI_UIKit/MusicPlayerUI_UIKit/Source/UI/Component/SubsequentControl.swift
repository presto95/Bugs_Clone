//
//  SubsequentControl.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/04.
//

import UIKit
import Combine
import MusicPlayerCommon

final class SubsequentControl: UIControl, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> { tapSubject.eraseToAnyPublisher() }

    private lazy var imageView = UIImageView()

    private var tapSubject = CurrentValueSubject<Void?, Never>(nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: MusicControlComponentProtocol

    func setNextMode(animated: Bool) {
        if animated {
            runScaleAnimation(to: imageView)
        }
    }
}

// MARK: - Private Method

private extension SubsequentControl {
    func configureViews() {
        addTarget(self, action: #selector(viewDidTap(_:)), for: .touchUpInside)

        imageView.do {
            $0.image = UIImage(systemName: "forward.end")
        }

        subviews {
            imageView
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func viewDidTap(_ sender: UIControl) {
        tapSubject.send(()) 
    }
}
