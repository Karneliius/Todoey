//
//  MainViewController.swift
//  Todoey
//
//  Created by Anelya Kabyltayeva on 09.03.2023.
//

import Foundation

import UIKit
import SnapKit
import CoreData

final class ItemViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [TodoeyItem]()
    
    private lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.searchBarStyle = .minimal
        return searchbar
    }()
    
    
    private lazy var itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.IDENTIFIER)
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        view.backgroundColor = .systemBackground
        
        DataManager.shared.delegate = self
        DataManager.shared.fetchItems()
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        searchBar.delegate = self
        
        setupViews()
        setupConstraints()
    }
}

//MARK: - Private controller methods

private extension ItemViewController {
    func configureNavBar(){
        navigationItem.title = "Todoey"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = add
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "New Item", message: "Create new item", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            
            DataManager.shared.createItem(with: text)
        }))
        
        present(alert, animated: true)
    }
}

//MARK: - Data manager delegate methods

extension ItemViewController: DataManagerDelegate{
    
    func didUpdateModelList(with models: [TodoeyItem]) {
        self.models = models
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print ("Following error appeared: ", error)
    }
    
    
}

//MARK: - Tableview data source methods

extension ItemViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.IDENTIFIER, for: indexPath) as! SectionTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: models[indexPath.row].name!)
        let num = CGFloat.random(in: 120...255)
        cell.backgroundColor = UIColor(red: num/255, green: num/255, blue: num/255, alpha: 1)
        return cell
    }
}

//MARK: - Tableview delegate methods

extension ItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Update Item", message: "Update your item", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = self.models[indexPath.row].name
            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
                DataManager.shared.updateItem(item: self.models[indexPath.row], newName: text)
            }))
            
            self.present(alert, animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in DataManager.shared.deleteItem(item: self.models[indexPath.row])
        }))
        
        present(sheet, animated: true)
    }
}

//MARK: - Searchbar delegate methods

extension ItemViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DataManager.shared.fetchItems(with: searchText)
    }
}

//MARK: - Setup views and constraints

private extension ItemViewController {
    
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(itemTableView)
    }
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
        itemTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

