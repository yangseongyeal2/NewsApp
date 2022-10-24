//
//  NewsListViewController.swift
//  KeywordNews
//
//  Created by Eunyeong Kim on 2021/08/24.
//

import SnapKit
import UIKit

final class NewsListViewController: UIViewController {
    private lazy var presenter = NewsListPresenter(viewController: self)

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didCalledRefresh), for: .valueChanged)

        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = presenter
        tableView.dataSource = presenter

        tableView.register(
            NewsListTableViewCell.self,
            forCellReuseIdentifier: NewsListTableViewCell.identifier
        )

        tableView.register(
            NewsListTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: NewsListTableViewHeaderView.identifier
        )

        tableView.refreshControl = refreshControl

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

extension NewsListViewController: NewsListProtocol {
    func setupNavigationBar() {
        navigationItem.title = "NEWS"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupLayout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    func moveToNewsWebViewController(with news: News) {
        let newsWebViewController = NewsWebViewController(news: news)
        navigationController?.pushViewController(newsWebViewController, animated: true)
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

private extension NewsListViewController {
    @objc func didCalledRefresh() {
        presenter.didCalledRefresh()
    }
}
