//
//  NewsListPresenter.swift
//  KeywordNews
//
//  Created by Eunyeong Kim on 2021/08/24.
//

import UIKit

protocol NewsListProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func endRefreshing()
    func moveToNewsWebViewController(with news: News)
    func reloadTableView()
}

final class NewsListPresenter: NSObject {
    private weak var viewController: NewsListProtocol?
    private let newsSearchManager: NewsSearchManagerProtocol

    private var currentKeyword = ""
    // 지금까지 request 된, 가지고 있는 보여주고 있는 page가 어디인지
    private var currentPage: Int = 0
    // 한 페이지에 최대 몇 개까지 보여줄건지
    private let display: Int = 20

    private let tags: [String] = ["IT", "아이폰", "개발", "개발자", "판교", "게임", "앱개발", "강남", "스타트업"]
    private var newsList: [News] = []

    init(
        viewController: NewsListProtocol,
        newsSearchManager: NewsSearchManagerProtocol = NewsSearchManager()
    ) {
        self.viewController = viewController
        self.newsSearchManager = newsSearchManager
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }

    func didCalledRefresh() {
        requestNewsList(isNeededToReset: true)
    }
}

extension NewsListPresenter: NewsListTableViewHeaderViewDelegate {
    func didSelectTag(_ selectedIndex: Int) {
        print("selectedIndex:\(selectedIndex)")
        currentKeyword = tags[selectedIndex]
        requestNewsList(isNeededToReset: true)
    }
}

extension NewsListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        viewController?.moveToNewsWebViewController(with: news)
    }

    func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentRow = indexPath.row
            
        print("currentRow: \(currentRow)")

        guard
            (currentRow % 20) == display - 3 && (currentRow / display) == (currentPage - 1)
        else {
            return
        }

        requestNewsList(isNeededToReset: false)
    }
}

extension NewsListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsListTableViewCell.identifier,
            for: indexPath
        ) as? NewsListTableViewCell

        if newsList.count > indexPath.row {
            let news = newsList[indexPath.row]
            cell?.setup(news: news)
            return cell ?? UITableViewCell()
        }
        else{
            return UITableViewCell()
        }
        
       
        
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsListTableViewHeaderView.identifier
        ) as? NewsListTableViewHeaderView
        header?.setup(tags: tags, delegate: self)

        return header
    }
}

private extension NewsListPresenter {
    func requestNewsList(isNeededToReset: Bool) {
        print("requset start")
        
        if isNeededToReset {
            currentPage = 0
            newsList = []
        }

        newsSearchManager.request(
            from: currentKeyword,
            start: (currentPage * display) + 1,
            display: display
        ) { [weak self] newValue in
            
                self?.newsList += newValue
                self?.currentPage += 1
                self?.viewController?.reloadTableView()
                self?.viewController?.endRefreshing()
           
         
        }
    }
}
