//
//  ViewController.swift
//  Simulator
//
//  Created by Карим Садыков on 04.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = MainViewModel()
    
    // MARK: - UI Components
    
    private let groupLabel = createLabel(text: LocalizableStrings.groupLabel)
    private let groupCountTextField = createTextField(text: LocalizableStrings.groupCountTextField, keyboardType: .numberPad)
    private let infectLabel = createLabel(text: LocalizableStrings.infectLabel)
    private let infectCountStepper = createStepper()
    private let infectCountLabel = createLabel(text: LocalizableStrings.infectCountLabel, weight: .regular, borderWidth: 1, borderColor: UIColor.gray.cgColor , cornerRadius: 5, backgroundColor: .white)
    private let periodLabel = createLabel(text: LocalizableStrings.periodLabel)
    private let periodCountTextField = createTextField(text: LocalizableStrings.periodCountTextField, keyboardType: .decimalPad)
    private let startButton = createStartButton()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        [groupLabel, groupCountTextField, infectLabel, infectCountStepper, infectCountLabel, periodLabel, periodCountTextField, startButton].forEach { view.addSubview($0) }
        startButton.addTarget(self, action: #selector(startSimulator), for: .touchUpInside)
        infectCountStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let toolbar = createToolbar()
        groupCountTextField.inputAccessoryView = toolbar
        periodCountTextField.inputAccessoryView = toolbar
    }
    
    static func createLabel(text: String, weight: UIFont.Weight = .bold, borderWidth: CGFloat = 0, borderColor: CGColor = UIColor.clear.cgColor, cornerRadius: CGFloat = 0, backgroundColor: UIColor = .clear) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: weight)
        label.layer.borderWidth = borderWidth
        label.layer.borderColor = borderColor
        label.clipsToBounds = true
        label.layer.cornerRadius = cornerRadius
        label.backgroundColor = backgroundColor
        return label
    }
    
    static func createTextField(text: String, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.keyboardType = keyboardType
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.placeholder = text
        return textField
    }
    
    private static func createStepper() -> UIStepper {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 8
        stepper.stepValue = 1
        stepper.value = 3
        return stepper
    }
    
    private static func createStartButton() -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle(LocalizableStrings.startButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        title = LocalizableStrings.titleMain
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc func startSimulator() {
        let (isValid, errorMessage) = viewModel.isValid(elements: groupCountTextField.text, delay: periodCountTextField.text)
        
        if !isValid {
            if let message = errorMessage {
                viewModel.presentAlert(on: self, withMessage: message)
            }
            return
        }
        
        let elements = Int(groupCountTextField.text!)!
        let neighbors = Int(infectCountStepper.value)
        let delayTextWithDot = periodCountTextField.text!.replacingOccurrences(of: ",", with: ".")
        let delay = Double(delayTextWithDot)!
        
        let simulatorVC = SimulatorViewController(elements: elements, neighbors: neighbors, delay: delay)
        simulatorVC.title = LocalizableStrings.simulatorTitle
        navigationController?.pushViewController(simulatorVC, animated: true)
    }
    
    @objc func stepperValueChanged() {
        infectCountLabel.text = "\(Int(infectCountStepper.value))"
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutView()
    }
    
    private func layoutView() {
        let padding: CGFloat = 20
        groupLabel.frame = CGRect(x: padding, y: view.layoutMargins.top, width: view.width - 2 * padding, height: 30)
        groupCountTextField.frame = CGRect(x: padding, y: groupLabel.bottom + 10, width: view.width - 2 * padding, height: 40)
        periodLabel.frame = CGRect(x: padding, y: groupCountTextField.bottom + 10, width: view.width - 2 * padding, height: 30)
        periodCountTextField.frame = CGRect(x: padding, y: periodLabel.bottom + 10, width: view.width - 2 * padding, height: 40)
        infectLabel.frame = CGRect(x: padding, y: periodCountTextField.bottom + 10, width: view.width - 2 * padding, height: 30)
        infectCountLabel.frame = CGRect(x: view.width / 2 - 25, y: infectLabel.bottom + 10, width: 50, height: 40)
        infectCountStepper.frame = CGRect(x: view.width / 2 - 50, y: infectCountLabel.bottom + 10, width: 100, height: 40)
        startButton.frame = CGRect(x: (view.width - 250) / 2, y: infectCountStepper.bottom + 50, width: 250, height: 50)
        startButton.layer.cornerRadius = startButton.height / 4
    }
}


