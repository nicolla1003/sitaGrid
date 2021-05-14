//
//  AirlineDetailsViewController.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import UIKit
import Combine
import CombineCocoa

class AirlineDetailsViewController: UIViewController, Storyboarded {
    private var disposables = Set<AnyCancellable>()
    private let loadTrigger = PassthroughSubject<Void, Never>()
    
    static var storyboardName: String = "Airlines"
    
    var coordinator: Airlinable?
    var viewModelBuilder: AirlineDetailsViewModel.Builder!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTrigger.send(())
    }
}

private extension AirlineDetailsViewController {
    func setup() {
        setupViewModel()
    }
    
    func setupViewModel() {
        let vm = createViewModel()
        bind(viewModel: vm)
    }
    
    func createViewModel() -> AirlineDetailsViewModel {
        let favoriteTrigger = favoriteButton.tapPublisher
            .map { !self.favoriteButton.isSelected }
            .eraseToAnyPublisher()
        
        return viewModelBuilder(loadTrigger.eraseToAnyPublisher(), favoriteTrigger)
    }
    
    func bind(viewModel: AirlineDetailsViewModel) {
        populateData(viewModel.airline)
        
        viewModel.favorite
            .receive(on: DispatchQueue.main)
            .sink(value: { [weak self] in
                print("Favorite \($0)")
                self?.favoriteButton.isSelected = $0
            })
            .store(in: &disposables)
        
        viewModel.image
            .receive(on: DispatchQueue.main)
            .sink(value: { [weak self] in
                self?.setImage($0)
            })
            .store(in: &disposables)
    }
    
    func populateData(_ airline: Airline) {
        imageView.isHidden = airline.imageUrl == nil
        
        nameLabel.text = airline.name
        countryLabel.text = airline.country ?? "/"
        activeLabel.text = airline.active ? "Yes" : "No"
        favoriteButton.isSelected = airline.favorite ==  .yes
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
