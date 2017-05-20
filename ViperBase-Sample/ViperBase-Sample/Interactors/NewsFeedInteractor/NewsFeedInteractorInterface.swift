//
//  NewsFeedInteractorInterface.swift
//  ViperBase-Sample
//
//  Created by SOL on 03.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

protocol NewsFeedInteractorInterface: InteractorInterface {
    func updateArticles(success: (()->Void)?, failure: ((Error)->Void)?)
    
    var numberOfArticles: Int { get }
    func articleId(at index: Int) -> NewsFeedArticleId
}
