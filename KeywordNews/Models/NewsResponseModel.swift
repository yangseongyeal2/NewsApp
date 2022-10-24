//
//  NewsResponseModel.swift
//  KeywordNews
//
//  Created by Eunyeong Kim on 2021/08/24.
//

import Foundation

struct NewsResponseModel: Decodable {
    var items: [News] = []
}

struct News: Decodable {
    let title: String
    let link: String
    let description: String
    let pubDate: String
}
