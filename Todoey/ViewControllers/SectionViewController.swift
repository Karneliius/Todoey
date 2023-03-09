//
//  ItemViewController.swift
//  Todoey
//
//  Created by Anelya Kabyltayeva on 08.03.2023.
//

import UIKit

final class SectionViewController: UIViewController {
    
    private var sections = [TodoeySection]()
    
    private lazy var sectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TodoeyTableViewCell.self, forCellReuseIdentifier: TodoeyTableViewCell.IDENTIFIER)
        tableView.separatorStyle = .none 
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        SectionManager.shared.delegate = self
        SectionManager.shared.fetchSections()
        
        configureNavBar()
        view.backgroundColor = .systemBlue
        
        sectionTableView.delegate = self
        sectionTableView.dataSource = self
        
        setupViews()
        setupConstraints()
        
    }
}
//MARK: - Private controller methods

private extension SectionViewController {
    func configureNavBar(){
        navigationItem.title = "Todoey"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        navigationItem.rightBarButtonItem = add
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "New Section", message: "Create new section",preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {_ in
            guard let field = alert.textFields?.first, let text = field.text,
                  !text.isEmpty else {return}
            SectionManager.shared.createSection(with: text)
        }))
        present(alert, animated: true)
    }
}
//MARK: - Section manager delegate methods

extension SectionViewController: SectionManagerDelegate {
    func didUpdateSections(with models: [TodoeySection]) {
        self.sections = models
        
        DispatchQueue.main.async {
            self.sectionTableView.reloadData()
        }
    }
}
//MARK: - Tableview data source methods

extension SectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoeyTableViewCell.IDENTIFIER, for: indexPath) as! TodoeyTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: sections[indexPath.row].name! )
        return cell
    }
}

//MARK: - Tableview delegate methods

extension SectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ItemViewController()
        viewController.configure(with: sections[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive,title: "Delete", handler: {_, _, _ in SectionManager.shared.deleteSection(section: self.sections[indexPath.row])
        }),UIContextualAction(style: .normal, title: "Edit", handler: { _, _, _ in
            let alert = UIAlertController(title: "Update Section", message: "Update your section", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = self.sections[indexPath.row].name
            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {_ in
                guard let field = alert.textFields?.first, let text = field.text,
                      !text.isEmpty else {return}
                SectionManager.shared.updateSection(section: self.sections[indexPath.row] , newName: text)
            }))
            
            self.present(alert, animated: true)
        })])
    }
}

//MARK: - Setup views and constraints

private extension SectionViewController {
    
    func setupViews() {
        view.addSubview(sectionTableView)
    }
    
    func setupConstraints(){
        sectionTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
