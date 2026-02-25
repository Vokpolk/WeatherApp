//
//  ViewController.swift
//  WeatherApp
//
//  Created by Александр Клопков on 22.02.2026.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WeatherApp"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let currentTemp: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let viewModel: WeatherViewModel = WeatherViewModel()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.start()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        [
            titleLabel,
            currentTemp
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            currentTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentTemp.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onWeatherLoaded = { [weak self] waether in
            self?.currentTemp.text = String(format: "%.1fC", waether.current.tempC)
        }
        
        viewModel.onLocationRequestStarted = { [weak self] in
            self?.currentTemp.text = "Определяем твое местоположение..."
        }
        
        viewModel.onError = { [weak self] title, message, retryHandler in
            self?.showAlert(
                title: title,
                message: message,
                retryHandler: retryHandler
            )
        }
    }
    private func showAlert(
        title: String,
        message: String, retryHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Еще раз",
                style: .default,
                handler: { _ in
                    retryHandler()
                }
            )
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

