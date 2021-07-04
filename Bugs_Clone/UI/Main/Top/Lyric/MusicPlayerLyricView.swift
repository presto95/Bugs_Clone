//
//  MusicPlayerLyricView.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/02.
//

import UIKit
import Combine

protocol LyricsViewProtocol: AnyObject {
    func selectLyricItem(before time: TimeInterval)
}

final class MusicPlayerLyricView: UIView {
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var topGradientView = UIView()
    private lazy var bottomGradientView = UIView()

    private var audioInteractor: AudioInteractable? {
        return DIContainer.shared.resolve(AudioInteractable.self)
    }

    private var viewModel: MusicPlayerLyricViewModel

    private var cancellables = Set<AnyCancellable>()

    var visibleLyricCells: [UITableViewCell] {
        return tableView.visibleCells
    }

    init(viewModel: MusicPlayerLyricViewModel) {
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

extension MusicPlayerLyricView: LyricsViewProtocol {
    func selectLyricItem(before time: TimeInterval) {
        guard let index = viewModel.lyrics?.index(before: time) else { return }
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }
}

extension MusicPlayerLyricView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let lyricCell = cell as? MusicPlayerLyricCell {
            let lyric = viewModel.lyrics?.lyric(at: indexPath.row)
            lyricCell.textLabel?.text = lyric
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lyrics?.count ?? 0
    }
}

extension MusicPlayerLyricView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)

        guard let lyricTime = viewModel.lyrics?.lyricTime(at: indexPath.row) else { return }
        audioInteractor?.updateCurrentTime(lyricTime)
        audioInteractor?.updateAudioCurrentTime(lyricTime)
    }
}

private extension MusicPlayerLyricView {
    func configureViews() {
        tableView.do {
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
            $0.register(MusicPlayerLyricCell.self, forCellReuseIdentifier: "cell")
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.estimatedRowHeight = UITableView.automaticDimension
        }

        topGradientView.do {
            $0.layer.addSublayer(CAGradientLayer().then {
                $0.startPoint = CGPoint(x: 0.5, y: 0)
                $0.endPoint = CGPoint(x: 0.5, y: 1)
                $0.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
                $0.locations = [0, 1]
            })
        }

        bottomGradientView.do {
            $0.layer.addSublayer(CAGradientLayer().then {
                $0.startPoint = CGPoint(x: 0.5, y: 0)
                $0.endPoint = CGPoint(x: 0.5, y: 1)
                $0.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
                $0.locations = [0, 1]
            })
        }

        addSubviews {
            tableView
        }

        tableView.addSubviews {
            topGradientView
            bottomGradientView
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topGradientView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }

        bottomGradientView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
    }

    func bindViewModel() {
        viewModel.$lyrics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}
