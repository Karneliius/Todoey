//
//  ItemViewController.swift
//  Todoey
//
//  Created by Anelya Kabyltayeva on 08.03.2023.
//

import UIKit

final class SectionViewController: UIViewController {
    
    private lazy var sectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.IDENTIFIER)
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        sectionTableView.delegate = self
        sectionTableView.dataSource = self
        view.backgroundColor = .systemBlue
        
        setupViews()
        setupConstraints()
        
    }
}
//MARK: - Private controller methods

private extension SectionViewController {
    func configureNavBar(){
        navigationItem.title = "Todoey"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = add
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "New Section", message: "Create new section", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            
      //       DataManager.shared.createItem(with: text)
        }))
        
        present(alert, animated: true)
    }
}


//MARK: - Tableview data source methods

extension SectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.IDENTIFIER, for: indexPath) as! SectionTableViewCell
        cell.selectionStyle = .none
        let num = CGFloat.random(in: 120...255)
        cell.backgroundColor = UIColor(red: num/255, green: num/255, blue: num/255, alpha: 1)
        return cell
    }
}

//MARK: - Tableview delegate methods

extension SectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let viewController = ItemViewController()
        // navigationController?.pushViewController(viewController, animated: true)
        print("Hi")
    }
}

//MARK: - Setup views and constraints

private extension SectionViewController {
    
    func setupViews() {
        view.addSubview(sectionTableView)
    }
    
    func setupConstraints() {
        sectionTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
