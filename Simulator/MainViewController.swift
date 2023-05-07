//
//  ViewController.swift
//  Simulator
//
//  Created by Карим Садыков on 04.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "Количество людей"
        label.textAlignment = .center
        return label
    }()

    private let groupCountTextField: UITextField = {
        let textField = UITextField()
//        textField.borderStyle = .bezel
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.keyboardType = .numberPad
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.text = "100"
        textField.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.05)
        return textField
    }()
    
    private let infectLabel: UILabel = {
        let label = UILabel()
        label.text = "Заразность"
        label.textAlignment = .center
        return label
    }()
    
    private let infectCountStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 8
        stepper.stepValue = 1
        stepper.value = 3
        return stepper
    }()
    
    private let infectCountLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.gray.cgColor
        label.textAlignment = .center
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.text = "Скорость заражения"
        label.textAlignment = .center
        return label
    }()
    
    private let periodCountTextField: UITextField = {
        let textField = UITextField()
//        textField.borderStyle = .bezel
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.keyboardType = .decimalPad
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.text = "1"
        textField.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.05)
        return textField
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.8421530128, blue: 0, alpha: 1)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(groupLabel)
        view.addSubview(groupCountTextField)
        view.addSubview(infectLabel)
        view.addSubview(infectCountStepper)
        view.addSubview(infectCountLabel)
        view.addSubview(periodLabel)
        view.addSubview(periodCountTextField)
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startSimulator), for: .touchUpInside)
        infectCountStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        let toolbar = createToolbar()
        groupCountTextField.inputAccessoryView = toolbar
        periodCountTextField.inputAccessoryView = toolbar
    }
    
    @objc func startSimulator() {
        let (isValid, errorMessage) = viewModel.isValid(elements: groupCountTextField.text, delay: periodCountTextField.text)
        
        if !isValid {
            if let message = errorMessage {
                viewModel.showAlert(on: self, message: message)
            }
            return
        }
        
        let elements = Int(groupCountTextField.text!)!
        let neighbors = Int(infectCountStepper.value)
        let delay = Double(periodCountTextField.text!)!
        
        let simulatorVC = SimulatorViewController(elements: elements, neighbors: neighbors, delay: delay)
        simulatorVC.title = "Simulator"
        navigationController?.pushViewController(simulatorVC, animated: true)
    }
    
    
    @objc func stepperValueChanged() {
        infectCountLabel.text = "\(Int(infectCountStepper.value))"
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Создайте UIToolbar
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        groupLabel.frame = CGRect(x: view.width/4, y: view.layoutMargins.top, width: view.width/2, height: 30)
        groupCountTextField.frame = CGRect(x: view.width/4, y: groupLabel.bottom + 10, width: view.width/2, height: 30)
        periodLabel.frame = CGRect(x: view.width/4, y: groupCountTextField.bottom + 10, width: view.width/2, height: 30)
        periodCountTextField.frame = CGRect(x: view.width/4, y: periodLabel.bottom + 10, width: view.width/2, height: 30)
        infectLabel.frame = CGRect(x: view.width/4, y: periodCountTextField.bottom + 10, width: view.width/2, height: 30)
        infectCountLabel.frame = CGRect(x: view.width/2 - 25, y: infectLabel.bottom + 10, width: 50, height: 30)
        infectCountStepper.frame = CGRect(x: view.width/2 - 50, y: infectCountLabel.bottom + 10, width: 100, height: 40)
        startButton.frame = CGRect(x: (view.width-200)/2, y: view.height - 150, width: 200, height: 50)
        startButton.layer.cornerRadius = startButton.height/4
    }
}
