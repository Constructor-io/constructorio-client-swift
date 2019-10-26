//
//  SearchViewController.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    let cellID = "SearchCell"

    let viewModel: SearchViewModel
    let constructorProvider: ConstructorIOProvider

    @IBOutlet weak var headerViewContainer: UIView!
    var headerView: FilterHeaderView

    init(viewModel: SearchViewModel, constructorProvider: ConstructorIOProvider){
        self.viewModel = viewModel
        self.constructorProvider = constructorProvider
        self.headerView = FilterHeaderView.instantiateFromNib()
        super.init(nibName: "SearchViewController", bundle: nil)
        self.headerView.tapDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        CartBarButtonItem.addToViewController(viewController: self, cart: self.viewModel.cart, constructorProvider: self.constructorProvider)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.cellID)

        self.reload()
        self.headerViewContainer.addSubviewToFit(self.headerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.viewModel.title
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = " "    
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.searchResults?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let model = self.viewModel.searchResults?[indexPath.row] else{
            return UICollectionViewCell()
        }
        cell.setup(viewModel: model)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = self.viewModel.searchResults?[indexPath.row] else {
            return
        }

        guard let cell = self.collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else {
            return
        }

        self.viewModel.constructor.trackSearchResultClick(itemName: model.title, customerID: "a-customer-id", searchTerm: self.viewModel.searchTerm, sectionName: nil, completionHandler: nil)

        let viewModel = DetailsViewModel(title: model.title, price: model.price, image: cell.imageView.image, imageURL: model.imageURL, description: model.description, cart: self.viewModel.cart)
        let detailsVC = DetailsViewController(viewModel: viewModel, constructorProvider: self.constructorProvider)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.viewModel.isLoading { return }
        if let items = self.viewModel.searchResults, indexPath.row < items.count-3 { return }
        
        let itemCountPre = self.viewModel.searchResults?.count ?? 0
        self.viewModel.performSearch { [weak self] newItems in
            guard let sself = self else { return }
         
            // track search results loaded
            sself.viewModel.constructor.trackSearchResultsLoaded(searchTerm: sself.viewModel.searchTerm, resultCount: newItems.count, completionHandler: nil)
           
            let itemCountPost = self?.viewModel.searchResults?.count ?? 0
            
            let indices = (itemCountPre..<itemCountPost).map{ IndexPath(row: $0, section: 0) }
            sself.collectionView.insertItems(at: indices)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = (self.view.frame.size.width - 3 * self.viewModel.margin) / 2
        let height = self.viewModel.cellAspectRatio * width

        let size = CGSize(width: width, height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        let margin = self.viewModel.margin
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return self.viewModel.margin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return self.viewModel.margin
    }
}

// MARK: Data
extension SearchViewController{
    func invalidateData(){
        self.viewModel.invalidate()
        self.collectionView.reloadData()
    }
    
    func reload(){
        self.viewModel.performSearch { [weak self] newItems in
            guard let sself = self else { return }
            
            // track search results loaded
            sself.viewModel.constructor.trackSearchResultsLoaded(searchTerm: sself.viewModel.searchTerm, resultCount: sself.viewModel.searchResults?.count ?? 0, completionHandler: nil)
            
            // reload table view
            sself.collectionView.reloadData()
        }
    }
}

extension SearchViewController: FilterHeaderDelegate{
    func didTapOnFilterView() {
        let viewModel = self.viewModel.filtersViewModel ?? FiltersViewModel(filters: [])
        let filtersViewController = FiltersViewController(viewModel: viewModel)
        viewModel.delegate = self
        let navController = UINavigationController(rootViewController: filtersViewController)
        self.present(navController, animated: true, completion: nil)
    }

    func didTapOnSortView() {
        let viewModel = self.viewModel.sortViewModel ?? SortViewModel(items: [])
        let sortViewController = SortOptionsViewController(viewModel: viewModel)
        viewModel.delegate = self
        let navController = UINavigationController(rootViewController: sortViewController)
        self.present(navController, animated: true, completion: nil)
    }
}

extension SearchViewController: FiltersSelectionDelegate{
    func didSelect(filters: [Filter]) {
        self.invalidateData()
        if filters.count == 0{
            self.headerView.labelFilter.text = "Filters"
        }else{
            self.headerView.labelFilter.text = "\(filters.count) selected"
        }
        self.reload()
    }
}

extension SearchViewController: SortSelectionDelegate{
    func didSelect(sortOption: SortOption?) {
        self.invalidateData()
        var image: UIImage?
        var title: String?
        if let selectedSortOption = sortOption{
            title = selectedSortOption.displayName
            image = UIImage.imageForSortOrder(selectedSortOption.sortOrder)
        }else{
            title = "Sort"
            image = UIImage(named: "icon_sort")
        }
        self.headerView.labelSort.text = title
        self.headerView.imageViewSort.image = image
        
        self.reload()
    }
}
