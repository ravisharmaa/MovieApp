//
//  CheckoutViewController.swift
//  MovieApp
//
//  Created by Ravi Bastola on 5/1/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class CheckoutViewController: UITableViewController {
    
    let pricesArray: [Int]
    let seatsArray: [String]
    
    let movieResult: MovieResult
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemBackground
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    
    init(pricesArray: [Int], seatsArray: [String], movieResult: MovieResult) {
        
        self.pricesArray = pricesArray
        self.seatsArray  = seatsArray
        self.movieResult = movieResult
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Ticket Info"
        
        view.backgroundColor = .systemBackground
        
        tableView.tableFooterView = UIView()
        
        collectionView.register(TicketCell.self, forCellWithReuseIdentifier: "reuseMe")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let items = NSCollectionLayoutItem(layoutSize: itemSize)
        
        items.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [items])
        
        let section  = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .paging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        if section == 0 {
            
            let header = UIView()
            
            header.addSubview(collectionView)
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: header.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: header.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: header.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            ])
            
            return header
        }
        
        // simply giving a dummy view makes tables happy 
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if section == 0 {
            return 300
        }
        
        return 20
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textLabel?.text = "Movie Name: \(movieResult.title)"
            return cell
        case 2:
            cell.textLabel?.text = "Poplarity: \(movieResult.popularity)"
            return cell
        case 3:
            cell.textLabel?.text = "Release Date: \(movieResult.releaseDate)"
            return cell
        case 4:
            cell.textLabel?.text = "Showtime: \(Calendar.current.component(.hour, from: Date())):" + "\(Calendar.current.component(.minute, from: Date()))"
            return cell
        case 5:
            cell.textLabel?.text = "Total Tickets: \(seatsArray.count)"
            return cell
        
        default:
            cell.textLabel?.text = "Total Price: \(pricesArray.reduce(0, +))"
            return cell
            
        }
    }
}

extension CheckoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return pricesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseMe", for: indexPath) as? TicketCell
        
        
        cell?.infoLabel.text = "Ticket No: " + seatsArray[indexPath.item] + "\n\n  Price: \(pricesArray[indexPath.item])"
        
        return cell!
    }
}
