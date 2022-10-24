//
//  NewsSearchManager.swift
//  KeywordNews
//
//  Created by Eunyeong Kim on 2021/08/24.
//

import Alamofire
import Foundation

protocol NewsSearchManagerProtocol {
    func request(
        from keyword: String,
        start: Int,
        display: Int,
        completionHandler: @escaping ([News]) -> Void
    )
}

struct NewsSearchManager: NewsSearchManagerProtocol {
    func request(
        from keyword: String,
        start: Int,
        display: Int,
        completionHandler: @escaping ([News]) -> Void
    ) {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/news.json") else { return }

        let parameters = NewsRequestModel(start: start, display: display, query: keyword)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "Paz9_qojs7Zfv5rc4VGa",
            "X-Naver-Client-Secret": "_NniQaC1Gh"
        ]

        AF
            .request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: NewsResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result.items)
                case .failure(let error):
                    print(error)
                }
            }
            .resume()
    }
}
