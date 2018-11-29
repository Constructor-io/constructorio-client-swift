//
//  CartViewController.swift
//  UserApplication
//
//  Created by Nikola Markovic on 11/27/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: CartViewModel

    let cellID = "CartCellID"

    init(viewModel: CartViewModel){
        self.viewModel = viewModel
        super.init(nibName: "CartViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI(){
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellID)
        
        self.tableView.allowsSelection = true
    }

    @IBAction func didTapOnButtonCheckout(_ sender: Any) {}
    
    @IBAction func didTapOnButtonClearCart(_ sender: Any) {
        if self.viewModel.items.count == 0{
            return
        }

        let alert = UIAlertController(title: nil, message: "Are you sure you want to remove all items from the cart?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            self?.removeAllItems()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func removeAllItems(){
        self.viewModel.removeAllItems()
        self.tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as! CartItemTableViewCell
        cell.selectionStyle = .none

        let model = self.viewModel.items[indexPath.row]
        cell.setup(model, index: indexPath.row)
        cell.onStepperValueChanged = { [weak self] sender, newValue, index in
            guard let newModel = self?.didUpdateQuantityValue(newValue: newValue, for: index) else { return }
            sender.setup(newModel, index: index)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        self.tableView.beginUpdates()
        self.viewModel.removeItemAtIndex(indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func didUpdateQuantityValue(newValue: Int, for index: Int) -> CartItemViewModel?{
        return self.viewModel.updateQuantity(newValue: newValue, for: index)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

}
