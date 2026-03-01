//
//  WeatherInfoViewCell.swift
//  WeatherApp
//
//  Created by Александр Клопков on 28.02.2026.
//

import UIKit
import SwiftUI

class WeatherViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "WeatherInfoViewCell"
    
    // MARK: - UI Elements
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with model: WeatherCellModel) {
        dateLabel.text = model.date
        timeLabel.text = model.time
        tempLabel.text = String(model.tempC)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 12
        [
            dateLabel,
            timeLabel,
            tempLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}


#Preview {
    let viewController = UIViewController()
    viewController.view.backgroundColor = .systemBackground
    
    let cell = WeatherViewCell(frame: CGRect(x: 100, y: 200, width: 150, height: 150))
    cell.backgroundColor = .lightGray.withAlphaComponent(0.3)
    
    let testModel = WeatherCellModel(
        date: "2024-01-15",
        time: "14:30",
        tempC: 22
    )
    cell.configure(with: testModel)
    
    viewController.view.addSubview(cell)
    return viewController
}
