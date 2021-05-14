//
//  AirlinesViewController.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import UIKit
import Combine

class AirlinesViewController: UIViewController, Storyboarded {
    private var disposables = Set<AnyCancellable>()
    private let searchTrigger = PassthroughSubject<String, Never>()
    
    static var storyboardName: String = "Airlines"
    
    var coordinator: Airlinable?
    var viewModelBuilder: AirlinesViewModel.Builder!
    private var dataSource: AirlinesDataSource!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

private extension AirlinesViewController {
    func setup() {
        searchBar.delegate = self
        setupViewModel()
    }
    
    func setupViewModel() {
        let vm = createViewModel()
        bind(viewModel: vm)
        createDataSource(with: vm.data)
    }
    
    func createViewModel() -> AirlinesViewModel {
        viewModelBuilder(searchTrigger.eraseToAnyPublisher())
    }
    
    func bind(viewModel: AirlinesViewModel) {
        viewModel.dataSaveComplete
            .receive(on: DispatchQueue.main)
            .sink(value: {
                print("Data saved locally")
            })
            .store(in: &disposables)
    }
    
    func createDataSource(with dataStream: AnyPublisher<[Airline], Error>) {
        dataSource = AirlinesDataSource(collectionView: collectionView, dataStream: dataStream)
        bindSelection(dataSource.itemSelected)
    }
    
    func bindSelection(_ itemSelected: AnyPublisher<Airline, Never>) {
        itemSelected
            .receive(on: DispatchQueue.main)
            .sink(value: { [weak self] in
                self?.openDetails(for: $0)
            })
            .store(in: &disposables)
    }
    
    func openDetails(for airline: Airline) {
        coordinator?.open(airline: airline)
    }
    
    func populateData(_ data: [Airline]) {
        print("Received airlines count: \(data.count)")
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+7.0) {
//            self.coordinator?.open(airline: data[1])
//        }
    }
}

extension AirlinesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTrigger.send(searchText)
    }
}
