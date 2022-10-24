//
//  MockNewsListViewController.swift
//  KeywordNewsTests
//
//  Created by Eunyeong Kim on 2021/08/24.
//

import Foundation
@testable import KeywordNews

final class MockNewsListViewController: NewsListProtocol {
    var isCalledSetupNavigationBar = false
    var isCalledSetupLayout = false
    var isCalledEndRefreshing = false
    var isCalledMoveToNewsWebViewContoller = false
    var isCalledReloadTableView = false

    func setupNavigationBar() {
        isCalledSetupNavigationBar = true
    }

    func setupLayout() {
        isCalledSetupLayout = true
    }

    func endRefreshing() {
        isCalledEndRefreshing = true
    }

    func moveToNewsWebViewController(with news: News) {
        isCalledMoveToNewsWebViewContoller = true
    }

    func reloadTableView() {
        isCalledReloadTableView = true
    }
}
