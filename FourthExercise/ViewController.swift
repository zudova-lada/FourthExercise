//
//  ViewController.swift
//  FourthExercise
//
//  Created by Лада Зудова on 10.03.2023.
//

import UIKit

final class ViewController: UIViewController {
    enum ViewControllerSection: Hashable{
        case main
    }
    
    private var items: [TableViewCellModel] = []
    
    private lazy var dataSource: UITableViewDiffableDataSource<ViewControllerSection, TableViewCellModel> = {
        let dataSource = UITableViewDiffableDataSource<ViewControllerSection, TableViewCellModel>(tableView: tableView) { tableView, _, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") else {
                return UITableViewCell()
            }
            cell.textLabel?.text = model.title
            if model.isSelect {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        return dataSource
    }()

    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffle))
        view.backgroundColor = .blue
        title = "Table"
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        view.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        createItems()
        configureSnapshot()
    }
    
    private func createItems() {
        ["один", "два", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять", "десять", "одиннадцать", "двенадцать", "тринадцать", "четырнадцать", "пятнадцать", "шестнадцать", "семнадцать", "восемнадцать", "девятнадцать", "двадцать", "двадцать один", "двадцать два", "двадцать три", "двадцать четыре", "двадцать пять", "двадцать шесть", "двадцать семь", "двадцать восемь", "двадцать девять", "тридцать", "тридцать один", "тридцать два", "тридцать три", "тридцать четыре","тридцать пять", "тридцать шесть", "тридцать семь", "тридцать восемь", "тридцать девять", "сорок", "сорок один", "42"].forEach {
            items.append(TableViewCellModel(title: $0, isSelect: false))
        }
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewControllerSection, TableViewCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
    @objc
    private func shuffle() {
        items.shuffle()
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let model = dataSource.itemIdentifier(for: indexPath),
            let firstItem = dataSource.itemIdentifier(for: IndexPath(row: 0, section: 0))
        else {
            return
        }
        
        model.isSelect = !model.isSelect
        var snapshot = dataSource.snapshot()
        var isNeedAnimations = false
        
        snapshot.reloadItems([model])
        
        if model.isSelect, model != firstItem {
            snapshot.moveItem(model, beforeItem: firstItem)
            isNeedAnimations = true
        }
        
        
        dataSource.apply(snapshot, animatingDifferences: isNeedAnimations)
    }
}

final class TableViewCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func == (lhs: TableViewCellModel, rhs: TableViewCellModel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    let title: String
    var isSelect: Bool
    
    init(title: String, isSelect: Bool = false) {
        self.title = title
        self.isSelect = isSelect
    }
}
