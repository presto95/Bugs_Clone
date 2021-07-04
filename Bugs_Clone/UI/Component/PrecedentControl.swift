//
//  PrecedentControl.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import UIKit

final class PrecedentControl: UIControl, MusicControl {
    @Published private(set) var didTap: Void?

    typealias Status = Void

    private lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func run() {
        runScaleAnimation()
        didTap = ()
    }
}

private extension PrecedentControl {
    func configureViews() {
        imageView.do {
            $0.image = UIImage(systemName: "backward.end")
        }

        addSubviews {
            imageView
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func runScaleAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut], animations: {
            self.imageView.transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        }, completion: { _ in
            self.imageView.transform = .identity
        })
    }
}
