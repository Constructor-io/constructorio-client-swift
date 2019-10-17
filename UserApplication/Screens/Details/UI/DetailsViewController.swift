//
//  DetailsViewController.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var buttonBuy: UIButton!

    let viewModel: DetailsViewModel
    let constructorProvider: ConstructorIOProvider
    var cartButton: CartBarButtonItem!

    init(viewModel: DetailsViewModel, constructorProvider: ConstructorIOProvider){
        self.viewModel = viewModel
        self.constructorProvider = constructorProvider
        super.init(nibName: "DetailsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

    }

    func setupUI(){
        self.cartButton = CartBarButtonItem.addToViewController(viewController: self, cart: self.viewModel.cart, constructorProvider: self.constructorProvider)

        self.labelDescription.text = self.viewModel.description
        if let image = self.viewModel.image{
            self.imageViewProduct.image = image
        }else{
            self.imageViewProduct.kf.setImage(with: URL(string: self.viewModel.imageURL))
        }

        self.buttonBuy.layer.cornerRadius = 6
        self.buttonBuy.layer.borderWidth = 0.8
        self.buttonBuy.layer.borderColor = UIColor.lightGray.cgColor

        self.buttonBuy.addTarget(self, action: #selector(didTapOnButtonBuy), for: .touchUpInside)
    }

    @objc
    func didTapOnButtonBuy(){

        let cartItem = CartItem(title: self.viewModel.title, imageURL: self.viewModel.imageURL, price: self.viewModel.price, quantity: 1)
        self.viewModel.cart.addItem(cartItem)
        self.cartButton.update()
        self.animateBuyProduct()
    }

    func animateBuyProduct(){
        // initialize animatable image view
        let imageView = UIImageView(image: self.imageViewProduct.image)
        imageView.contentMode = self.imageViewProduct.contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // convert frame to window coordinates
        let animatableImageViewFrame = self.view.convert(self.imageViewProduct.frame, to: nil)
        imageView.frame = animatableImageViewFrame

        // add subview to window
        let window = UIApplication.shared.windows.first!
        window.addSubview(imageView)

        let barButtonItemView = self.navigationItem.rightBarButtonItem!.value(forKey: "view") as! UIView
        let targetFrame = barButtonItemView.superview!.convert(barButtonItemView.frame, to: nil)

        // animate
        UIView.animate(withDuration: 0.5, animations: {
            imageView.frame = targetFrame
            imageView.alpha = 0
        }) { _ in
            imageView.removeFromSuperview()
        }
    }
}
