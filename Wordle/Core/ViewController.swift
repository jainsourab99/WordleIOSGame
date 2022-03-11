//
//  ViewController.swift
//  Wordle
//
//  Created by Sourabh Jain on 12/03/22.
//

import UIKit

// UI
// Keyboard
// Game board
// Orange/Green

class ViewController: UIViewController {
    
    let answers = ["after", "later", "green", "apple"]
    var answer = ""
    private var guess: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6)
    
    let KeyboardVC = Wordle.KeyboardViewController()
    let BoardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        answer = answers.randomElement() ?? "after"
        self.title = "WORDLE"
        self.addChildern()
    }
    
    private func addChildern() {
        addChild(KeyboardVC)
        KeyboardVC.didMove(toParent: self)
        KeyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        KeyboardVC.delegate = self
        view.addSubview(KeyboardVC.view)
        
        addChild(BoardVC)
        BoardVC.didMove(toParent: self)
        BoardVC.dataSource = self
        BoardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(BoardVC.view)
        
        self.addConstraint()
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            BoardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            BoardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            BoardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            BoardVC.view.bottomAnchor.constraint(equalTo: KeyboardVC.view.topAnchor),
            BoardVC.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
            
            KeyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            KeyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            KeyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ViewController: KeyboardViewControllerDelegate {
    func KeyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        debugPrint(letter)
        var stop = false
        
        for i in 0..<guess.count {
            for j in 0..<guess[i].count {
                if guess[i][j] == nil {
                    guess[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
        BoardVC.reloadData()
    }
}

extension ViewController: BoardViewControllerDataSource {
    var currentguesses: [[Character?]] {
        return guess
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        
        let count = guess[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }
        
        let indexedAnswer = Array(answer)
        guard let letter = guess[indexPath.section][indexPath.row], indexedAnswer.contains(letter) else {
            return nil
        }
        
        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        return .systemOrange
    }
}

