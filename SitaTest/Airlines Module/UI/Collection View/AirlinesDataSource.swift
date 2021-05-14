//
//  AirlinesDataSource.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import UIKit
import Combine

class AirlinesDataSource: NSObject {
    private var disposables = Set<AnyCancellable>()
    private weak var collectionView: UICollectionView?
    private var data: [Airline] = []
    private var itemSelectedSubject = PassthroughSubject<Airline, Never>()
    
    private let itemsPerRow = 3
    private let insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    var itemSelected: AnyPublisher<Airline, Never> {
        itemSelectedSubject.eraseToAnyPublisher()
    }
    
    init(collectionView: UICollectionView, dataStream: AnyPublisher<[Airline], Error>) {
        super.init()
        
        self.collectionView = collectionView
        configure()
        bindForUpdates(dataStream)
    }
    
    deinit {
        disposables.forEach { $0.cancel() }
    }
}

private extension AirlinesDataSource {
    func bindForUpdates(_ dataStream: AnyPublisher<[Airline], Error>) {
        dataStream
            .receive(on: DispatchQueue.main)
            .sink(value: { [weak self] in
                self?.reload(with: $0)
            })
            .store(in: &disposables)
    }
    
    func configure() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    func reload(with data: [Airline]) {
        self.data = data
        collectionView?.reloadData()
    }
    
    func item(at indexPath: IndexPath) -> Airline {
        data[indexPath.row]
    }
}

extension AirlinesDataSource: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AirlineCollectionCell.identifier,
                                                      for: indexPath) as! AirlineCollectionCell
        
        let item = item(at: indexPath)
        cell.setup(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let padding = insets.left * CGFloat(itemsPerRow + 1)
        let fullWidth = collectionView.frame.width - padding
        let width = fullWidth / CGFloat(itemsPerRow)

        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        insets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = item(at: indexPath)
        itemSelectedSubject.send(item)
    }
    
    
}
