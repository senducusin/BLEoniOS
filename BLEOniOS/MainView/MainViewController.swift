//
//  MainViewController.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/3/24.
//

import UIKit

protocol MainViewControllerProtocol {
    func updateSections(with model: PeripheralUIModel)
    func navigateToDetails(with model: CharacteristicData)
}

class MainViewController: UIViewController {
    @IBOutlet weak private var topDashboardView: UIView!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var refreshButton: UIButton!
    
    @IBOutlet weak private var peripheralNameLabel: UILabel!
    @IBOutlet weak private var peripheralLocalNameLabel: UILabel!
    @IBOutlet weak private var servicesLabel: UILabel!
    @IBOutlet weak private var characteristicsLabel: UILabel!
    
    private var rows = [CharacteristicRow]()
    
    var presenter: MainViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
        setupDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()

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
        
        peripheralNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        peripheralNameLabel.textColor = ColorContext.primaryText
        
        peripheralLocalNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        peripheralLocalNameLabel.textColor = ColorContext.primaryText
        
        servicesLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        servicesLabel.textColor = ColorContext.secondaryText
        
        characteristicsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        characteristicsLabel.textColor = ColorContext.secondaryText
    }
    
    private func setupDefault() {
        peripheralNameLabel.text = "Peripheral not found"
        peripheralLocalNameLabel.text = ""
        servicesLabel.text = ""
        characteristicsLabel.text = ""
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
        
        let row = rows[indexPath.row]
        
        switch row {
        case let .commonCharacteristic(model):
            presenter?.didSelectRow(with: model)
        default:
            break
        }
    }
}

extension MainViewController: MainViewControllerProtocol {
    func navigateToDetails(with model: CharacteristicData) {
        let controller = CharacteristicDetailView()
        
        let presenter = CharacteristicDetailPresenter(controller: controller,
                                                      model: model)
        
        controller.presenter = presenter
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateSections(with model: PeripheralUIModel) {
        peripheralNameLabel.text = model.peripheralIdentity?.name
        peripheralLocalNameLabel.text = model.peripheralIdentity?.localName
        servicesLabel.text = "\(model.servicesCount) Services Found"
        characteristicsLabel.text = "\(model.characteristicRows.count) Characteristics Found"
        
        self.rows = model.characteristicRows
        tableView.reloadData()
    }
}
