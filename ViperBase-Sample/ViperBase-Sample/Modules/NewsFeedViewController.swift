//
//  NewsFeedViewController.swift
//  ViperBase-Sample
//
//  Created by SOL on 03.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

private let articleCellEstimatedHeight: CGFloat = 144

final class NewsFeedViewController: PresentableViewController {
    @IBOutlet var tableView: UITableView!
}

// MARK: - Fileprivate
fileprivate extension NewsFeedViewController {
    final var presenter: NewsFeedPresenterInterface {
        return presenterInterface as! NewsFeedPresenterInterface
    }
}

// MARK: - NewsFeedViewInterface
extension NewsFeedViewController: NewsFeedViewInterface {
    func reloadNewsFeed() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfArticles
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableCell.identifier, for: indexPath) as! NewsFeedTableCell
        cell.setup(viewModel: presenter.articleViewModel(at: indexPath.row))
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.articleTapped(at: indexPath.row)
    }
}

// MARK: - ContentContainerInterface
extension NewsFeedViewController {
    override func setupContent() {
        super.setupContent()
        
        tableView.register(UINib(nibName: NewsFeedTableCell.identifier, bundle: nil),
                           forCellReuseIdentifier: NewsFeedTableCell.identifier)
        
        tableView.estimatedRowHeight = articleCellEstimatedHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        title = "News"
    }
}
