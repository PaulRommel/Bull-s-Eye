//
//  ViewController.swift
//  Bull's Eye
//
//  Created by Павел Попов on 19.09.2026.
//

import UIKit

final class ViewController: UIViewController {
    
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0
    
    private static let fontName = "ArialRoundedMTBold"
    
    // MARK: - Фон
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Background"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Кнопка Hit Me!
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Hit Me!", for: .normal)
        button.titleLabel?.font = UIFont(name: ViewController.fontName, size: 20)
        button.setTitleColor(UIColor(white: 0.2, alpha: 1), for: .normal)
        button.setTitleShadowColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.shadowOffset = CGSize(width: 0, height: 1)
        button.setBackgroundImage(UIImage(named: "Button-Normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "Button-Highlighted"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Ряд 1: два лейбла
    
    private let promptLabel = ViewController.makeLabel("Put the Bull's Eye as close as you can to:")
    private let targetLabel = ViewController.makeLabel("100", size: 20)
    
    // MARK: - Ряд 2: лейбл - слайдер - лейбл
    
    private let minLabel = ViewController.makeLabel("1")
    private let maxLabel = ViewController.makeLabel("100")
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = 50
        slider.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // бегунок
        slider.setThumbImage(UIImage(named: "SliderThumb-Normal"), for: .normal)
        slider.setThumbImage(UIImage(named: "SliderThumb-Highlighted"), for: .highlighted)
        
        // дорожка — растягиваемые картинки, края по 14 pt не тянутся
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        if let left = UIImage(named: "SliderTrackLeft") {
            slider.setMinimumTrackImage(left.resizableImage(withCapInsets: insets), for: .normal)
        }
        if let right = UIImage(named: "SliderTrackRight") {
            slider.setMaximumTrackImage(right.resizableImage(withCapInsets: insets), for: .normal)
        }
        return slider
    }()
    
    // MARK: - Ряд 3: кнопка, 2 пары лейблов, кнопка
    
    private let startOverButton = ViewController.makeSmallButton(icon: "StartOverIcon")
    
    private let scoreTitleLabel = ViewController.makeLabel("Score:")
    private let scoreValueLabel = ViewController.makeLabel("0", size: 20)
    private let roundTitleLabel = ViewController.makeLabel("Round:")
    private let roundValueLabel = ViewController.makeLabel("1", size: 20)
    
    private let infoButton = ViewController.makeSmallButton(icon: "InfoButton")
    
    // MARK: - Стеки
    
    private lazy var promptStack = ViewController.makeHStack(
        [promptLabel, targetLabel], spacing: 8)
    
    private lazy var sliderStack = ViewController.makeHStack(
        [minLabel, slider, maxLabel], spacing: 12)
    
    // пары «заголовок + значение» стоят вплотную
    private lazy var scoreStack = ViewController.makeHStack(
        [scoreTitleLabel, scoreValueLabel], spacing: 4)
    
    private lazy var roundStack = ViewController.makeHStack(
        [roundTitleLabel, roundValueLabel], spacing: 4)
    
    // 4 группы равномерно по ширине
    private lazy var statsStack = ViewController.makeHStack(
        [startOverButton, scoreStack, roundStack, infoButton],
        spacing: 8, distribution: .equalSpacing)
    
    // MARK: - Жизненный цикл
    
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // фон — первым, чтобы оказался под всеми элементами
        view.addSubview(backgroundImageView)
        [promptStack, sliderStack, actionButton, statsStack].forEach(view.addSubview)
        
        let safeArea = view.safeAreaLayoutGuide
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            // фон — на весь экран
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ряд 1 — у верха экрана
            promptStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            promptStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptStack.leadingAnchor.constraint(greaterThanOrEqualTo: margins.leadingAnchor),
            promptStack.trailingAnchor.constraint(lessThanOrEqualTo: margins.trailingAnchor),
            
            // ряд 2 — под первым рядом
            sliderStack.topAnchor.constraint(equalTo: promptStack.bottomAnchor, constant: 20),
            sliderStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            sliderStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            // кнопка — по центру экрана, размер картинки 100×37
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionButton.topAnchor.constraint(greaterThanOrEqualTo: sliderStack.bottomAnchor, constant: 24),
            actionButton.widthAnchor.constraint(equalToConstant: 100),
            actionButton.heightAnchor.constraint(equalToConstant: 37),
            
            // маленькие кнопки — 32×32
            startOverButton.widthAnchor.constraint(equalToConstant: 32),
            startOverButton.heightAnchor.constraint(equalToConstant: 32),
            infoButton.widthAnchor.constraint(equalToConstant: 32),
            infoButton.heightAnchor.constraint(equalToConstant: 32),
            
            // ряд 3 — прижат к низу экрана
            statsStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            statsStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            statsStack.topAnchor.constraint(greaterThanOrEqualTo: actionButton.bottomAnchor, constant: 24)
        ])
        
        // слайдер → обновляем currentValue
        slider.addAction(UIAction { [weak self] action in
            guard let slider = action.sender as? UISlider else { return }
            self?.sliderMoved(slider)
        }, for: .valueChanged)
        
        // кнопка → алерт
        actionButton.addAction(UIAction { [weak self] _ in
            self?.showAlert()
        }, for: .touchUpInside)
        
        // кнопка Start Over → новая игра
        startOverButton.addAction(UIAction { [weak self] _ in
            self?.startNewGame()
        }, for: .touchUpInside)
        
        // кнопка info → экран About
        infoButton.addAction(UIAction { [weak self] _ in
            let aboutVC = AboutViewController()
            aboutVC.modalPresentationStyle = .fullScreen
            aboutVC.modalTransitionStyle = .flipHorizontal
            self?.present(aboutVC, animated: true)
        }, for: .touchUpInside)
        
        startNewGame()
    }
    
    // MARK: - Фабрики
    
    private static func makeLabel(_ text: String, size: CGFloat = 16) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: fontName, size: size) ?? .boldSystemFont(ofSize: size)
        label.textColor = .white
        
        // тень, как в книге: чёрная 50 %, смещение вниз на 1 pt
        label.shadowColor = UIColor.black.withAlphaComponent(0.5)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }
    
    private static func makeSmallButton(icon: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "SmallButton"), for: .normal)
        button.setImage(UIImage(named: icon), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private static func makeHStack(_ views: [UIView],
                                   spacing: CGFloat,
                                   distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = spacing
        stack.distribution = distribution
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    // MARK: - Действия
    
    private func showAlert() {
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference
        
        let title: String
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        
        score += points
        
        let alert = UIAlertController(
            title: title,
            message: "You scored \(points) points",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.startNewRound()
        })
        present(alert, animated: true)
    }
    
    private func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    private func startNewRound() {
        round += 1
        currentValue = 50
        targetValue = Int.random(in: 1...100)
        slider.value = Float(currentValue)
        updateLabels()
    }
    
    private func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreValueLabel.text = String(score)
        roundValueLabel.text = String(round)
    }
    
    private func startNewGame() {
        score = 0
        round = 0
        startNewRound()
    }
}
