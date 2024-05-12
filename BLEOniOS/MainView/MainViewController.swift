//
//  MainViewController.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/3/24.
//

import UIKit

protocol MainViewControllerProtocol {
    func updateSections(with rows: [CharacteristicRow])
}

class MainViewController: UIViewController {
    @IBOutlet weak private var topDashboardView: UIView!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var refreshButton: UIButton!
    
    private var rows = [CharacteristicRow]()
    
    var presenter: MainViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        setupUI()
//        dump("DEBUG will appear")
    }
}

extension MainViewController {
    private func setupUI() {
        setupBackground()
        setupTitle()
        setupTopDashboard()
        setupTableview()
        
        refreshButton.backgroundColor = ColorContext.lightBlue
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.tintColor = .white
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.clipsToBounds = false
        refreshButton.layer.cornerRadius = 5
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

    }
    
    private func setupTableview() {
        tableView.backgroundColor = .white
        tableView.addDropShadow()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(cellClass: CharacteristicViewCell.self)
        tableView.separatorStyle = .none
    }
    
    private func setupTopDashboard() {
        topDashboardView.addDropShadow()
        topDashboardView.backgroundColor = .white
    }
    
    private func setupTitle() {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Bluetooth App"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        let screenWidth = UIScreen.main.bounds.width * 1.1
        
        let circlePathX = UIScreen.main.bounds.width/2
        let circlePathY = -(UIScreen.main.bounds.width/7)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circlePathX, y: circlePathY),
                                      radius: CGFloat(screenWidth/1.5),
                                      startAngle: 0,
                                      endAngle: (CGFloat(Double.pi * 2)),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 3
        
        let circleColor = ColorContext.lightBlue
        shapeLayer.fillColor = circleColor.cgColor
        shapeLayer.strokeColor = circleColor.cgColor
        shapeLayer.zPosition = -1
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func navigateToDetails() {
        let controller = CharacteristicDetailView()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        
        switch row {
        case .noCharactersticFound:
            return UITableViewCell()
        case .commonCharacteristic(model: let model):
            let cell = tableView.dequeueReusableCell(cellClass: CharacteristicViewCell.self)
            cell.set(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToDetails()
    }
}

extension MainViewController: MainViewControllerProtocol {
    func updateSections(with rows: [CharacteristicRow]) {
        self.rows = rows
        tableView.reloadData()
    }
}
