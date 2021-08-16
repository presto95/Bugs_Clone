//
//  MusicPlayerLyricsView.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/02.
//

import UIKit
import Combine
import MusicPlayerCommon
import Common

protocol LyricsViewProtocol: AnyObject {
    func selectLyricItem(before time: TimeInterval)
    func unselectLyricItem()
}

final class MusicPlayerLyricsView: UIView {
    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    private var musicInteractor: MusicInteractable? {
        return DIContainer.shared.resolve(MusicInteractable.self)
    }

    private var viewModel: MusicPlayerLyricsViewModel

    private var cancellables = Set<AnyCancellable>()

    var visibleLyricCells: [UITableViewCell] {
        return tableView.visibleCells
    }

    init(viewModel: MusicPlayerLyricsViewModel) {
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

// MARK: - Interface

extension MusicPlayerLyricsView {
    func updateSelectedLyricAlignmentToCenterY() {
        guard let selectedIndex = tableView.indexPathForSelectedRow?.row else { return }
        tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: false, scrollPosition: .middle)
    }
}

// MARK: - LyricsViewProtocol

extension MusicPlayerLyricsView: LyricsViewProtocol {
    func selectLyricItem(before time: TimeInterval) {
        guard let index = viewModel.lyrics?.index(before: time),
              tableView.indexPathForSelectedRow?.row != index else { return }
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }

    func unselectLyricItem() {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedIndexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension MusicPlayerLyricsView: UITableViewDataSource {
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

// MARK: - UITableViewDelegate

extension MusicPlayerLyricsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lyricTime = viewModel.lyrics?.lyricTime(at: indexPath.row) else { return }

        musicInteractor?.updateCurrentTime(lyricTime)
        musicInteractor?.updateMusicCurrentTime(lyricTime)

        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}

// MARK: - Private Method

private extension MusicPlayerLyricsView {
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

        subviews {
            tableView
        }

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.trailing.equalToSuperview()
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
