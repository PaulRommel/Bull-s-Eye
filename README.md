🎯 Bull's Eye

Игра для iOS: передвиньте слайдер как можно ближе к случайному числу от 1 до 100. Чем точнее попадание, тем больше очков.

Учебный проект по книге UIKit Apprentice (Fahim Farook, Kodeco). Всё сделано на UIKit, а интерфейс свёрстан полностью кодом, без Storyboard и Interface Builder.

Демо

https://github.com/user-attachments/assets/896c6ff6-a4b5-430e-8039-add364bf1945

Возможности
Случайное целевое число в каждом раунде
Подсчёт очков: 100 − разница плюс бонусы
точное попадание: +100
промах на 1: +50
Алерт с оценкой результата: Perfect! / You almost had it! / Pretty good! / Not even close...
Счёт и номер раунда, кнопка Start Over для новой игры
Экран About с правилами, открывается с анимацией переворота
Оформление на своих картинках: фон, кнопки, бегунок и дорожка слайдера
Только альбомная ориентация на iPhone, скрытый статус-бар
Технологии
	
Язык	Swift
UI	UIKit, вёрстка кодом
Layout	Auto Layout (NSLayoutConstraint), UIStackView
События	UIAction / addAction(_:for:) вместо @IBAction
Кнопки	UIButton(type: .custom) с фоновыми картинками для состояний
Слайдер	setThumbImage, resizableImage(withCapInsets:) для дорожки
Чем отличается от книги

В книге интерфейс собирается в Interface Builder. Здесь каждый элемент создаётся в коде:

лейблы и стеки создаются через фабричные методы makeLabel, makeHStack, makeSmallButton;
@IBOutlet заменены на приватные свойства, @IBAction — на addAction;
экран About показывается через present(_:animated:) с modalTransitionStyle = .flipHorizontal вместо segue.
Структура
Bull's Eye/
├── ViewController.swift        # главный экран и логика игры
├── AboutViewController.swift   # экран с правилами
└── Assets.xcassets             # фон, кнопки, слайдер
Запуск
Клонируйте репозиторий
Откройте проект в Xcode
Выберите симулятор iPhone и нажмите ⌘R
Благодарности

Идея игры и графика взяты из книги UIKit Apprentice (Kodeco). Проект сделан в учебных целях.
