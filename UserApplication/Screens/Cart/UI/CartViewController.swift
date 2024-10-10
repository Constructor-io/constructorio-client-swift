//
//  CartViewController.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonCheckout: UIButton!
    @IBOutlet weak var buttonClearCart: UIButton!
    @IBOutlet weak var labelTotalPrice: UILabel!
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
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        let colorBrown = UIColor.RGB(183, green: 173, blue: 142)
        self.buttonCheckout.setTitleColor(colorBrown, for: .normal)
        self.buttonCheckout.layer.borderColor = colorBrown.cgColor
        self.buttonCheckout.layer.borderWidth = 1.2
        self.buttonCheckout.backgroundColor = .white
        self.buttonCheckout.titleLabel?.font = UIFont.appFontSemiBold(self.buttonCheckout.titleLabel?.font.pointSize ?? 14)
        
        self.buttonClearCart.setTitleColor(colorBrown, for: .normal)
        self.buttonClearCart.layer.borderColor = colorBrown.cgColor
        self.buttonClearCart.layer.borderWidth = 1.2
        self.buttonClearCart.backgroundColor = .white
        
        self.labelTotalPrice.font = UIFont.appFontSemiBold(self.labelTotalPrice.font.pointSize)
        
        self.updateTotalPrice()
    }

    @IBAction func didTapOnButtonCheckout(_ sender: Any) {
        let itemCount = self.viewModel.cart.quantity
        if itemCount == 0{
            return
        }

        let itemCountString = "\(itemCount)"
        let alert = UIAlertController(title: "Success", message: "You have successfully bought \(itemCountString) items.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great!", style: .default, handler: nil))

        self.viewModel.constructor.trackPurchase(customerIDs: ["customer-id-1"], sectionName: nil, completionHandler: nil)

        self.present(alert, animated: true) { [weak self] in
            guard let sself = self else { return }
            sself.viewModel.removeAllItems()
            sself.tableView.reloadData()
        }
    }
    
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

    func cartDidChange(){
        self.updateTotalPrice()
    }
    
    func updateTotalPrice(){
        self.labelTotalPrice.text = self.viewModel.totalPrice   
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
        cell.setup(model)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        self.tableView.beginUpdates()
        self.viewModel.removeItemAtIndex(indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
        
        self.cartDidChange()
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

}
