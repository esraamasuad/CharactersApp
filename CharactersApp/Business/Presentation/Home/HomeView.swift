//
//  ViewController.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/19/24.
//

import UIKit
import SwiftUI
import Kingfisher
import Combine

class HomeView: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var filterCollectionView: UICollectionView! {
        didSet {
            filterCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet var charactersCollectionView: UICollectionView! {
        didSet {
            charactersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            charactersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "loadingCell")
        }
    }
    
    private var cancellable: AnyCancellable?
    
    private let viewModel: HomeViewModel = .init()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters"
        setUp()
        viewModel.getCharacters()
        cancellable = viewModel.objectWillChange.sink(receiveValue: { [weak self] in
            self?.render()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    /// SetUp CollectionView Delegate + Swipe to refresh
    func setUp() {
        [filterCollectionView, charactersCollectionView].forEach({ collection in
            collection?.delegate = self
            collection?.dataSource = self
        })
        
        charactersCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    @objc private func pullToRefresh(_ sender: Any) {
        viewModel.refresh()
    }
    
    /// Reload to update the list
    private func render() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.charactersCollectionView.reloadData()
            self.filterCollectionView.reloadData()
        }
    }
    
}

//MARK: - UICollectionView [DataSource + Delegate]
extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case filterCollectionView:
            return 1
        case charactersCollectionView:
            return ((viewModel.page < viewModel.totalPages) && !viewModel.pullToRefresh && !viewModel.charactersList.isEmpty) ? 2 : 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filterCollectionView:
            return viewModel.filterList.count
        case charactersCollectionView:
            return (section == 0) ? viewModel.charactersList.count : 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == charactersCollectionView {
            /// Render Pagination Cell Loading if exist -->
            if (collectionView.numberOfSections == 2 && indexPath.section == 1) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
                cell.contentConfiguration = UIHostingConfiguration {
                    VStack {
                        ProgressView("Loading").progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }.id(UUID())
                }
                return cell
            } else {
                /// Character Cell
                let item = viewModel.charactersList[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.contentConfiguration = UIHostingConfiguration {
                    VStack(alignment: .center) {
                        Spacer()
                        HStack {
                            ImageFisher(url: (item.image ?? ""))
                                .frame(width: 64, height: 64)
                            
                            VStack(alignment: .leading) {
                                Text(item.name ?? "").bold()
                                Text(item.species ?? "")
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.gray, lineWidth: 0.5))
                }
                return cell
            }
        } else {
            /// Filter Cell
            let item  = viewModel.filterList[indexPath.row].rawValue
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.contentConfiguration = UIHostingConfiguration {
                HStack {
                    Text(item).bold()
                    Spacer()
                }
                //                .background((viewModel.status == item ) ? Color.cyan : Color.white)
                .padding(.horizontal,15)
                .padding(.vertical,5)
                .background {
                    RoundedRectangle(cornerRadius: 20, style: .continuous).fill((viewModel.status == item ) ? Color.cyan : Color.white)
                    RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(Color.gray, lineWidth: 0.5)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case filterCollectionView:
            viewModel.resetFilter(index: indexPath.row)
            break
        case charactersCollectionView:
            if (indexPath.section == 0) {
                let selectedItem = viewModel.charactersList[indexPath.row]
                let hostController = UIHostingController(rootView: DetailsView(viewModel: DetailsViewModel(characherDetails: selectedItem)))
                self.navigationController?.pushViewController(hostController, animated: true)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == charactersCollectionView {
            if viewModel.page < viewModel.totalPages, indexPath.row == viewModel.charactersList.count - 1 {
                viewModel.getCharacters()
            }
        }
    }
}

//MARK: - UICollectionView [FlowLayout]
extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (collectionView == filterCollectionView) ?
        CGSize(width: 100, height: 50) :
        CGSize(width: collectionView.bounds.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

