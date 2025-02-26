//
//  SimulatorViewController.swift
//  Simulator
//
//  Created by Карим Садыков on 04.05.2023.
//

import UIKit

class SimulatorViewController: UIViewController {
    
    // MARK: - Properties
    
    private var timer: Timer?
    private var startTime: Date?
    let viewModel: SimulatorViewModel
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.backgroundColor = .secondarySystemBackground
        return scrollView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: GroupCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.backgroundColor = .clear
        return collView
    }()
    
    private let healthyPeopleLabel = createLabel()
    private let timeLabel = createLabel()
    private let infectedPeopleLabel = createLabel()
    
    // MARK: - Initialization
    
    init(elements: Int, neighbors: Int, delay: Double) {
        viewModel = SimulatorViewModel(elements: elements, neighbors: neighbors, delay: delay)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - UI Setup
    
    private static func createLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .secondarySystemBackground
        label.textAlignment = .center
        return label
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        view.addSubview(healthyPeopleLabel)
        view.addSubview(timeLabel)
        view.addSubview(infectedPeopleLabel)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        scrollView.delegate = self
        updateLabels()
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUI()
    }
    
    private func layoutUI() {
        let labelHeight: CGFloat = 30
        let labelSpacing: CGFloat = 25
        let timeLabelWidth: CGFloat = 50
        
        healthyPeopleLabel.frame = CGRect(x: 0, y: view.layoutMargins.top, width: view.width / 2 - labelSpacing, height: labelHeight)
        timeLabel.frame = CGRect(x: view.width / 2 - labelSpacing , y: view.layoutMargins.top, width: timeLabelWidth, height: labelHeight)
        infectedPeopleLabel.frame = CGRect(x: view.frame.width / 2 + labelSpacing, y: view.layoutMargins.top, width: view.width / 2 - labelSpacing, height: labelHeight)
        
        scrollView.frame = CGRect(x: 0, y: timeLabel.bottom, width: view.frame.width, height: view.height - timeLabel.height - view.layoutMargins.top)
        collectionView.frame = scrollView.bounds
    }
    // MARK: - Alert
    
    func showAlert() {
        let alertController = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage(timeLabelText: timeLabel.text ?? ""), preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: viewModel.restartButtonTitle, style: .default) { [weak self] _ in
            self?.restartSimulation()
        }
        
        let returnAction = UIAlertAction(title: viewModel.returnButtonTitle, style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(restartAction)
        alertController.addAction(returnAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Simulation
    
    func restartSimulation() {
        viewModel.resetMatrix()
        collectionView.reloadData()
        updateLabels()
    }
    
    private func updateTimerLabel() {
        let elapsedTime = Int(Date().timeIntervalSince(startTime ?? Date()))
        let elapsedTimeString = String(format: "%02d:%02d", elapsedTime / 60, elapsedTime % 60)
        timeLabel.text = "\(elapsedTimeString)"
    }
    
    func updateLabels() {
        healthyPeopleLabel.text = "\(LocalizableStrings.healthy)\(viewModel.numberOfZeroes)"
        infectedPeopleLabel.text = "\(LocalizableStrings.infected)\(viewModel.numberOfOnes)"
    }
}

// MARK: - UICollectionViewDataSource

extension SimulatorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.matrixController.matrix.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.matrixController.matrix[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier, for: indexPath) as! GroupCollectionViewCell
        cell.select(value: viewModel.matrixController.matrix[indexPath.section][indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SimulatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if timer == nil {
            startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateTimerLabel()
            }
        }
        
        viewModel.spreadOnes(startRow: indexPath.section, startColumn: indexPath.item, neighbors: viewModel.neighbors, delay: viewModel.delay, onChange: { [weak self] changedCoordinates in
            guard let self = self else { return }
            let changedIndexPaths = changedCoordinates.map { IndexPath(item: $0.col, section: $0.row) }
            DispatchQueue.main.async {
                collectionView.reloadItems(at: changedIndexPaths)
                self.updateLabels()
            }
        }, completion: { [weak self] in
            DispatchQueue.main.async {
                self?.timer?.invalidate()
                self?.timer = nil
                self?.startTime = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.showAlert()
                }
            }
        })
    }
}
extension SimulatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 3
        let totalSpacing = CGFloat(viewModel.numberOfColumns - 1) * padding
        let cellWidth = (collectionView.bounds.width - totalSpacing) / CGFloat(viewModel.numberOfColumns)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

// MARK: - UIScrollViewDelegate

extension SimulatorViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return collectionView
    }
}
