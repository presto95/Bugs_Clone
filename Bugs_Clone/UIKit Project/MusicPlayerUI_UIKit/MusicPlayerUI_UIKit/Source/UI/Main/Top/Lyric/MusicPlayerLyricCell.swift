//
//  MusicPlayerLyricCell.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/08/08.
//

import UIKit

final class MusicPlayerLyricCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            textLabel?.textColor = .label
        } else {
            textLabel?.textColor = .systemGray
        }
    }
}

private extension MusicPlayerLyricCell {
    func configureViews() {
        backgroundColor = .clear
        selectionStyle = .none

        textLabel?.do {
            $0.textAlignment = .center
            $0.font = .preferredFont(forTextStyle: .footnote)
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview().offset(16)
                make.trailing.lessThanOrEqualToSuperview().offset(-16)
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
            }
        }
    }
}
