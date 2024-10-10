//
//  SortOptionsViewController.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

class SortOptionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel: SortViewModel

    let cellSortID = "cellSortID"

    init(viewModel: SortViewModel){
        self.viewModel = viewModel
        self.viewModel.changed = false
        super.init(nibName: "SortOptionsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "SortOptionTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellSortID)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapOnButtonDone))
    }

    @objc
    func didTapOnButtonDone(){
        self.viewModel.dismiss()
        self.dismiss(animated: true, completion: nil)
    }

}

extension SortOptionsViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellSortID) as! SortOptionTableViewCell
        let item = self.viewModel.items[indexPath.row]
        cell.labelSort.text = item.displayName
        cell.imageViewSort.image = item.image
        cell.accessoryType = item.selected ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.toggle(indexPath: indexPath)
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

}
