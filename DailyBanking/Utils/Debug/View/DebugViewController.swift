//
//  DebugViewController.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2020. 07. 06..
//

import UIKit

class DebugViewController: UIViewController {
    // MARK: - Constants

    private let heightForRow: CGFloat = 20.0

    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    var items = [DebugMenuItem]()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func reload(with items: [DebugMenuItem]) {
        self.items = items
        tableView.reloadData()
    }

    @objc
    func close() {
        dismiss(animated: true)
    }

    // MARK: - Private Interface

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let item = items[indexPath.item]
        if let action = item.action {
            switch action {
            case .navigation:
                cell.accessoryType = .disclosureIndicator
            case .execution:
                cell.accessoryType = .none
            }
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.detailTextLabel?.numberOfLines = 0
    }

    private func handleItem(at indexPath: IndexPath) {
        let item = items[indexPath.item]
        guard let action = item.action else {
            return
        }
        switch action {
        case .navigation(let destination):
            if let navigationController = navigationController {
                let viewController = destination(navigationController)
                viewController.title = item.title
                navigationController.pushViewController(viewController, animated: true)
            }
        case .execution(let action):
            action(self, item)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DebugViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForRow
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        configure(cell, at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return items[indexPath.item].action != nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleItem(at: indexPath)
    }
}
