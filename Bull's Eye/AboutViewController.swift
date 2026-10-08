//
//  AboutViewController.swift
//  Bull's Eye
//
//  Created by Павел Попов on 08.10.2026.
//

import UIKit
import WebKit

final class AboutViewController: UIViewController {
    
    // MARK: - Фон
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Background"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Веб-вью с правилами игры
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        // прозрачный фон, чтобы под ним был виден Background
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Кнопка Close — в том же стиле, что Hit Me!
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        button.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
        button.setTitleShadowColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.shadowOffset = CGSize(width: 0, height: 1)
        button.setBackgroundImage(UIImage(named: "Button-Normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "Button-Highlighted"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Жизненный цикл
    
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [backgroundImageView, webView, closeButton].forEach(view.addSubview)
        
        let safeArea = view.safeAreaLayoutGuide
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            // фон — на весь экран
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // кнопка Close — по центру внизу
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 37),
            
            // текст — всё пространство над кнопкой
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            webView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20)
        ])
        
        closeButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
        
        loadAboutPage()
    }
    
    // MARK: - Загрузка BullsEye.html из бандла
    
    private func loadAboutPage() {
        guard let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html") else {
            print("BullsEye.html не найден — добавьте файл в проект и отметьте таргет")
            return
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
}

