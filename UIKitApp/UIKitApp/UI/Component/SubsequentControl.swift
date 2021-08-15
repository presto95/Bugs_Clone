//
//  SubsequentControl.swift
//  UIKitApp
//
//  Created by Presto on 2021/07/04.
//

import UIKit

final class SubsequentControl: UIControl {
    @Published private(set) var tap: Void?

    private lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MusicControl

extension SubsequentControl: MusicControl {
    func setNextStatus(animated: Bool) {
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

    func runScaleAnimation() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.autoreverse, .curveEaseInOut],
                       animations: {
                        self.imageView.transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
                       },
                       completion: { _ in
                        self.imageView.transform = .identity
                       })
    }

    @objc func viewDidTap(_ sender: UIControl) {
        tap = ()
    }
}
