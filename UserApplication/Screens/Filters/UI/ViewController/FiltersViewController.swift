//
//  FiltersViewController.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/12/19.
//  Copyright © 2019 xd. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    let viewModel: FiltersViewModel
    let cellFilter = "CellFilter"

    init(viewModel: FiltersViewModel){
        self.viewModel = viewModel
        self.viewModel.changed = false
        super.init(nibName: "FiltersViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellFilter)
        self.tableView.tableFooterView = UIView(frame: .zero)
            
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapOnButtonDone))
    }

    @objc
    func didTapOnButtonDone(){
        self.viewModel.dismiss()
        self.dismiss(animated: true, completion: nil)
    }

}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.filters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filters[section].options.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = self.viewModel.filters[section]
        return item.title
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellFilter) as! FilterTableViewCell
        let item = self.viewModel.filters[indexPath.section].options[indexPath.row]
        cell.labelTitle?.text = item.title
        cell.accessoryType = item.selected ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.toggle(indexPath: indexPath)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }

}
