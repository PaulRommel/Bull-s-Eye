//
//  ViewController.swift
//  Bull's Eye
//
//  Created by Павел Попов on 19.09.2026.
//

import UIKit

final class ViewController: UIViewController {
    
    var currentValue: Int = 0
    var targetValue = 0
    
    //MARK: - Кнопка Hit Me!
    
    private lazy var actionButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Hit Me!"
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Ряд 1: два лейбла
    
    private let promptLabel = ViewController.makeLabel("Put the Bull's Eye as close as you can to:")
    private let targetLabel = ViewController.makeLabel("100", weight: .bold)
    
    //MARK: - Ряд 2: лейбл - слайдер - лейбл
    
    private let minLabel = ViewController.makeLabel("1")
    private let maxLabel = ViewController.makeLabel("100")
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = 50
        slider.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return slider
    }()
    
    //MARK: - Ряд 3: кнопка, 2 пары лейблов, кнопка
    
    private let startOverButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Start Over"
        return UIButton(configuration: config)
    }()
    
    private let scoreTitleLabel = ViewController.makeLabel("Score:", size: 15)
    private let scoreValueLabel = ViewController.makeLabel("0", size: 15, weight: .semibold)
    private let roundTitleLabel = ViewController.makeLabel("Round:", size: 15)
    private let roundValueLabel = ViewController.makeLabel("1", size: 15, weight: .semibold)
    
    private let infoButton = UIButton(type: .infoLight)
    
    //MARK: - Стеки
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Вызов метода генерации случайных чисел
        startNewRound()
        
        [promptStack, sliderStack, actionButton, statsStack].forEach(view.addSubview)
        
        let safeArea = view.safeAreaLayoutGuide
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            // ряд 1 — у верха экрана
            promptStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            promptStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptStack.leadingAnchor.constraint(greaterThanOrEqualTo: margins.leadingAnchor),
            promptStack.trailingAnchor.constraint(lessThanOrEqualTo: margins.trailingAnchor),
            
            // ряд 2 — под первым рядом
            sliderStack.topAnchor.constraint(equalTo: promptStack.bottomAnchor, constant: 20),
            sliderStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            sliderStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            // кнопка — по центру экрана, но не ближе 24 pt к слайдеру
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionButton.topAnchor.constraint(greaterThanOrEqualTo: sliderStack.bottomAnchor, constant: 24),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
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
    }
    
    // MARK: - Фабрики
    
    private static func makeLabel(_ text: String,
                                  size: CGFloat = 17,
                                  weight: UIFont.Weight = .regular) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = .label
        return label
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
        let message = "The value of the slider is: \(currentValue)" + "\n The target value is: \(targetValue)"
        
        let alert = UIAlertController(
            title: "Hello, World",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.startNewRound()
        })
        present(alert, animated: true, completion: nil)
        print("The value of the slider is now: \(slider.value)")
    }
    
    private func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    private func startNewRound() {
        // начальное значение — из положения слайдера
        currentValue = 50
        // целевое значение
        targetValue = Int.random(in: 1...100)
        slider.value = Float(currentValue)
        
        // Вызов метода
        updateLabels()
    }
    
    private func updateLabels() {
        targetLabel.text = String(targetValue)
    }
}

