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
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .medium)
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 12
        collectionView.register(
            WeatherViewCell.self,
            forCellWithReuseIdentifier: WeatherViewCell.identifier
        )
        
        return collectionView
    }()
    
    private let viewModel: WeatherViewModel = WeatherViewModel()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupBindings()
        viewModel.start()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        [
            titleLabel,
            countryLabel,
            regionLabel,
            nameLabel,
            currentTemp,
            collectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            countryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            regionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regionLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 5),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 5),
            
            currentTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentTemp.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.onWeatherLoaded = { [weak self] weather in
            self?.countryLabel.text = weather.location.country
            self?.regionLabel.text = weather.location.region
            self?.nameLabel.text = weather.location.name
            self?.currentTemp.text = String(format: "Текущая: %.1fC", weather.current.tempC)
        }
        
        viewModel.onLocationRequestStarted = { [weak self] in
            self?.countryLabel.text = ""
            self?.regionLabel.text = ""
            self?.nameLabel.text = ""
            self?.currentTemp.text = "Определяем твое местоположение..."
        }
        
        viewModel.onCellsUpdated = { [weak self] in
            self?.collectionView.reloadData()
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

extension MainViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.cellModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherViewCell.identifier,
            for: indexPath
        ) as? WeatherViewCell else {
            return UICollectionViewCell()
        }
        
        let model = viewModel.cellModels[indexPath.item]
        cell.configure(with: model)
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
