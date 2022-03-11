//
//  BoardViewController.swift
//  Wordle
//
//  Created by Sourabh Jain on 12/03/22.
//

import UIKit

protocol BoardViewControllerDataSource: AnyObject {
    var currentguesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath) -> UIColor?
}

class BoardViewController: UIViewController {
    
    weak var dataSource: BoardViewControllerDataSource?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .darkGray
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.currentguesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let guess = dataSource?.currentguesses ?? []
        return guess[section].count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {
            fatalError()
        }
        
        cell.backgroundColor = dataSource?.boxColor(at: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        
        let guesses = dataSource?.currentguesses ?? []
        if let guess = guesses[indexPath.section][indexPath.row] {
            cell.configure(with: guess)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width - margin) / 5
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
//        var left: CGFloat = 1
//        var right: CGFloat = 1
        
//        let margin: CGFloat = 20
//        let size: CGFloat = (collectionView.frame.size.width - margin) / 10
//
//        let count: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
//
//        let inset: CGFloat = (collectionView.frame.size.width - (size * count) - (2 * count)) / 2
//
//        left = inset
//        right = inset
        
        return UIEdgeInsets(
                            top: 2,
                            left: 2,
                            bottom: 2,
                            right: 2
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}

