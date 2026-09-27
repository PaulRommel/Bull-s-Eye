//
//  ViewController.swift
//  Bull's Eye
//
//  Created by Павел Попов on 19.09.2026.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var actionButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Hit Me!"
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        actionButton.addAction(UIAction { [weak self] _ in
            self?.showAlert()
        }, for: .touchUpInside)
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Hello, World",
            message: "This is my first app!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Awesome", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

