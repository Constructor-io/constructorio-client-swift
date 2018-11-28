//
//  CartBarButtonItem.swift
//  UserApplication
//
//  Created by Nikola Markovic on 11/27/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit

class CartBarButtonItem: UIBarButtonItem {

    private(set) weak var parentController: UIViewController?
    weak var cart: Cart?

    private let badgeView = BadgeView()

    @discardableResult
    class func addToViewController(viewController: UIViewController, cart: Cart) -> CartBarButtonItem{
        let cartButton = CartBarButtonItem(viewController: viewController, cart: cart)
        viewController.navigationItem.rightBarButtonItem = cartButton
        return cartButton
    }

    init(viewController: UIViewController, cart: Cart){
        super.init()
        self.parentController = viewController
        self.cart = cart

        let imageView = UIImageView(image: UIImage(named: "icon_cart"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        self.customView = imageView

        self.badgeView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(badgeView)
        self.badgeView.pinToSuperviewRight()
        self.badgeView.pinToSuperviewTop()
        let dim: CGFloat = 14
        self.badgeView.pinHeight(dim)
        self.badgeView.pinWidth(dim)
        self.update()

        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnButtonCart)))

        NotificationCenter.default.addObserver(forName: kNotificationCartDidChange, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.update()
        }
    }

    func update(){
        guard let cart = self.cart else { return }
        self.badgeView.setValue(text: "\(cart.quantity)")
    }

    func setBadgeValue(value: String){
        self.badgeView.setValue(text: value)
    }

    func setBadgeValue(intValue: Int){
        self.setBadgeValue(value: "\(intValue)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func didTapOnButtonCart(){
        guard let cart = self.cart else { return }
        let viewModel = CartViewModel(cart: cart)
        let cartVC = CartViewController(viewModel: viewModel)
        parentController?.navigationController?.pushViewController(cartVC, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
