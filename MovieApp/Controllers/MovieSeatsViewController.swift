//
//  DiffableController.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/30/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class MovieSeatsViewController: UIViewController {
    
    //MARK:- Instance Properties
    
    let rowArray: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N"]
    
    var selectedIndexPaths: [IndexPath] = []
    
    var price: Int = 0
    
    var seatInfo: String = ""
    
    var dataSource: UICollectionViewDiffableDataSource<MovieSections, Int>!
    
    var visualQueueHeightConstraint: NSLayoutConstraint?
    
    var visualQueueBottomConstraint: NSLayoutConstraint?
    
    var movieResult: MovieResult? {
        
        didSet {
            
            guard let posterPath = movieResult?.posterPath else { return }
            
            guard let url = URL(string: "https://image.tmdb.org/t/p/w185/" + posterPath) else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {[weak self] in
                    self?.visualQueueView.imageView.image = UIImage(data: data)
                }
                
            }.resume()
            
        }
    }
    
    //MARK:- UI Properties
    
    lazy var dummyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bouncesZoom = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    
    lazy var visualQueueView: VisualQueueView = {
        let view = VisualQueueView()
        view.proceedButton.addTarget(self, action: #selector(proceedToCheckout), for: .touchUpInside)
        return view
    }()
    
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureCellsAndSuppplementaryViews()
        
        layoutConstraintsForCollectionViewAndScrollView()
        
        configureDataSource()
        
        NetworkManager.shared.sendRequest(to: "movie", model: Movie.self, queryItems: ["query":"god"]) { [weak self] (result) in
            
            switch result {
            case .success(let movie):
                self?.movieResult = movie.results.first
                
                DispatchQueue.main.async {[weak self] in
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    //MARK:- Layout Creation
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionLayout = MovieSections(rawValue: sectionIndex) else { fatalError() }
            
            //MARK:- Badges to show seat definition
            let badgeAnchor = NSCollectionLayoutAnchor(edges: [.bottom], fractionalOffset: .init(x: 0.0, y: 0.5))
            
            let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
            
            let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: "badge-element-kind", containerAnchor: badgeAnchor)
            
            //MARK:- Compositional Layout Item Definition
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 20, trailing: 5)
            
            //MARK:- Compostional Layout Group Definition
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: MovieSections.columnCount)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 5, bottom: 5, trailing: 3)
            
            
            //MARK:- Compositional Layout Header And Footer Defnition
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(sectionLayout.headerSize))
            
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(sectionLayout.footerSize))
            
            let headerView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let headerFootercontentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            
            headerView.contentInsets = headerFootercontentInsets
            
            
            let footerView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            
            footerView.contentInsets = headerFootercontentInsets
            
            //MARK:- Compositional Layout Section Definition
            let section = NSCollectionLayoutSection(group: group)
            
            
            section.boundarySupplementaryItems = [headerView, footerView]
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            
            return section
            
        }
        
        return layout
    }
    
    //MARK:- Cell and Views Registration
    
    fileprivate func configureCellsAndSuppplementaryViews() {
        collectionView.register(SeatsCell.self, forCellWithReuseIdentifier: SeatsCell.reuseIdentifier)
        collectionView.register(ScreenView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ScreenView.reuseId)
        collectionView.register(ScreenView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ScreenView.reuseId)
        collectionView.register(BadgeView.self, forSupplementaryViewOfKind: "badge-element-kind", withReuseIdentifier: "badge-view")
    }
    
    //MARK:- Custom Methods
    
    func layoutConstraintsForCollectionViewAndScrollView() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(dummyView)
        
        dummyView.addSubview(collectionView)
        
        view.addSubview(visualQueueView)
        
        // For showing and hiding the toolbar could be aksed why not use the default?, easy you cannot customise the default one
        // So the gist is manipulate the constraints..
        
        visualQueueHeightConstraint = visualQueueView.heightAnchor.constraint(equalToConstant: 0)
        
        visualQueueHeightConstraint?.isActive = true
        
        visualQueueBottomConstraint = visualQueueView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        visualQueueBottomConstraint?.constant = 20
        
        visualQueueBottomConstraint?.isActive = true
        
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: visualQueueView.topAnchor),
            
            visualQueueView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            visualQueueView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualQueueView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            dummyView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            dummyView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dummyView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            dummyView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            dummyView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            dummyView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: dummyView.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: dummyView.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: dummyView.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: dummyView.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    //MARK:- DataSource Configuration
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<MovieSections, Int>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, index: Int) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatsCell.reuseIdentifier, for: indexPath)
                as? SeatsCell else { fatalError()}
            
            cell.section = MovieSections(rawValue: indexPath.section)!
            
            return cell
        })
        
        //MARK:- Supplementary Views Configuration
        
        dataSource.supplementaryViewProvider = {(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ScreenView.reuseId, for: indexPath)
                    as? ScreenView else { fatalError("Could not dequeue the reusable view")}
                
                return header
                
            } else if kind == UICollectionView.elementKindSectionFooter {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ScreenView.reuseId, for: indexPath)
                    as? ScreenView else { fatalError("Could not deque the footer ")}
                
                return footer
                
            } else {
                guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "badge-view", for: indexPath)
                    as? BadgeView else { fatalError()}
                
                supplementary.seatLabel.text = self.getStringFor(indexPath)
                
                return supplementary
            }
        }
        
        //MARK:- SnapShot Configuration
        
        var snapshot = NSDiffableDataSourceSnapshot<MovieSections, Int>()
        
        MovieSections.allCases.forEach { (section) in
            snapshot.appendSections([section])
            switch section {
            case .audi14:
                snapshot.appendItems(Array(0..<168))
            case .audi30:
                snapshot.appendItems(Array(169..<529))
            }
        }
        
        dataSource.apply(snapshot)
    }
    
}

//MARK:- Scroll View Delegate

extension MovieSeatsViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.dummyView
    }
    
}

//MARK:- Collection View Delegate

extension MovieSeatsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // need to reset the price for selection,
        // if not done then the price is calculated with previous selected index
        
        let section = MovieSections(rawValue: indexPath.section)!
        
        //print(section.randomSeats) //uncomment this to see random seats so that you can test the unavailable feature
        
        if section.randomSeats.contains(indexPath.item) {
            
            presentUnavailableAlert()
            
            return
        }
        
        
        price = 0
        
        seatInfo = ""
        
        selectedIndexPaths.append(indexPath)
        
        for path in selectedIndexPaths {
            price +=  getPriceFrom(path)
            seatInfo += "\(getStringFor(path)),"
        }
        
        // need to call this to let know autolayout to re-layout the views
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.4,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.visualQueueHeightConstraint?.constant = (self?.selectedIndexPaths.count ?? 0 > 0) ? 120 : 0
                        self?.visualQueueBottomConstraint?.constant = (self?.selectedIndexPaths.count ?? 0 > 0) ? 0 : 20
                        self?.view.layoutIfNeeded()
            }, completion: nil)
        
        visualQueueView.priceLabel.text = "Total Price: \(price)"
        
        let atttributedString = NSMutableAttributedString(string: "Seats:", attributes: nil)
        atttributedString.append(NSAttributedString(string: seatInfo, attributes: [.font: UIFont.systemFont(ofSize: 15)]))
        
        visualQueueView.selectedSeatsLabel.attributedText = atttributedString
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let section = MovieSections(rawValue: indexPath.section)!
        
        if section.randomSeats.contains(indexPath.item) {
            presentUnavailableAlert()
            return
        }
        
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(at: selectedIndexPaths.firstIndex(of: indexPath)!)
            price -= getPriceFrom(indexPath)
        }
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.visualQueueHeightConstraint?.constant = (self?.selectedIndexPaths.count ?? 0 > 0) ? 120 : 0
                        self?.visualQueueBottomConstraint?.constant = (self?.selectedIndexPaths.count ?? 0 > 0) ? 0 : 20
                        self?.view.layoutIfNeeded()
            }, completion: nil)
        
        
        visualQueueView.priceLabel.text = "Total Price: \(price)"
        
        seatInfo = ""
        
        for path in selectedIndexPaths {
            seatInfo += "\(getStringFor(path)),"
        }
        
        let atttributedString = NSMutableAttributedString(string: "Seats:", attributes: nil)
        atttributedString.append(NSAttributedString(string: seatInfo, attributes: [.font: UIFont.systemFont(ofSize: 15)]))
        
        visualQueueView.selectedSeatsLabel.attributedText = atttributedString
        
    }
}

//MARK:- Utility Methods, (Class Specific)

extension MovieSeatsViewController {
    
    fileprivate func getStringFor(_ indexPath: IndexPath) -> String {
        return "\(rowArray[getIndexNumber(indexPath)] + "\(getRowNumber(indexPath)+1)")"
    }
    
    fileprivate func getRowNumber(_ indexPath: IndexPath) -> Int {
        return (indexPath.item ) / 12
    }
    
    func getIndexNumber(_ indexPath: IndexPath) -> Int {
        return indexPath.item % 12
    }
    
    fileprivate func getPriceFrom(_ path: IndexPath) -> Int {
        return (getRowNumber(path) == 0) || (getRowNumber(path) == 1 ) ? 500 : 400
    }
    
    @objc func proceedToCheckout(sender: UIButton) {
        
        var seatsArray: [String] = [String]()
        
        var pricesArray: [Int] = [Int]()
        
        for path in selectedIndexPaths {
            pricesArray.append(getPriceFrom(path))
            seatsArray.append(getStringFor(path))
        }
        
        guard let movieResult = movieResult else { return }
        
        let viewController = CheckoutViewController(pricesArray: pricesArray, seatsArray: seatsArray, movieResult: movieResult)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    fileprivate func presentUnavailableAlert() {
        
        let alertController = UIAlertController(title: "Cannot Proceed Futher!", message: "The seat you seleted is unavilable. Please choose another.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
