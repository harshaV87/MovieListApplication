//
//  ViewController.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import UIKit

class MovieListViewController: UIViewController, UISearchResultsUpdating {
    
    
    // Properties for initialisation and UI

    var rootViewModel : CompositeViewModel!
    
    var networkService : DataAPI!
    
    private let listTableView = UITableView()
    
    private let nowPlayingCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    var searchViewController: UISearchController = UISearchController(searchResultsController: nil)
    
    var searchResults: [ListResult] = []
    

    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        propertiesAndMethodsToInitialise()
           
    }
    
    

    // MARK: Getting data through ViewModel
    private func getCurrentMovieList() {
        
        self.rootViewModel.getNowPlayingList { [weak self] (vmout) in
            
            self?.rootViewModel = vmout
            
            DispatchQueue.main.async {
                
                self?.nowPlayingCollectionView.reloadData()
            }
            
        }
        
    }
    
    
    private func getAllMovieList() {
        
        self.rootViewModel.getAllMovieList(pageNo: 1) { [weak self] (vmout) in
            
            self?.rootViewModel = vmout
            
            DispatchQueue.main.async {
                
                self?.listTableView.reloadData()
            }
            
        }
        
    }
    
    // Properties and methods for viewdidload
    
    private func propertiesAndMethodsToInitialise() {
        
        settingUpTableCollectionViews()
             
        setUpUIViews()
             
        self.networkService = DataAPI()
             
        self.rootViewModel = CompositeViewModel(service: networkService)
             
        getCurrentMovieList()
             
        getAllMovieList()
        
        searchBarUI()

    }
    
    // Table and collectionview registration
    
    func settingUpTableCollectionViews() {
        
        listTableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: Properties.tableCellID)
        listTableView.dataSource = self
        listTableView.delegate = self
        
        nowPlayingCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: Properties.collectionCellID)
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
    
    }
    
    // MARK: UI Aspects
    
    let collectionHeaderLabel : UILabel = {
        
        let collectionHeaderLabel = UILabel()
        collectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionHeaderLabel.numberOfLines = 7
        collectionHeaderLabel.textAlignment = .justified
        collectionHeaderLabel.backgroundColor = .black
        collectionHeaderLabel.textColor = .white
        collectionHeaderLabel.text = "Playing Now"
        collectionHeaderLabel.adjustsFontSizeToFitWidth = false
        collectionHeaderLabel.sizeToFit()
        return collectionHeaderLabel
        
    }()

    // Autolayout
    
    func setUpUIViews() {
        
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        nowPlayingCollectionView.setCollectionViewLayout(layout, animated: true)
        nowPlayingCollectionView.backgroundColor = UIColor.black
        listTableView.backgroundColor = UIColor.black
        
        view.addSubview(collectionHeaderLabel)
        view.addSubview(listTableView)
        view.addSubview(nowPlayingCollectionView)
        
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionHeaderLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionHeaderLabel.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 0.05).isActive = true
        
        nowPlayingCollectionView.topAnchor.constraint(equalTo: collectionHeaderLabel.bottomAnchor).isActive = true
        nowPlayingCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nowPlayingCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nowPlayingCollectionView.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 0.35).isActive = true
    
        listTableView.topAnchor.constraint(equalTo: nowPlayingCollectionView.bottomAnchor).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       
    }
    
    // MARK: SearchBar Aspects
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let textToBeLowercased = searchViewController.searchBar.text?.lowercased()
        filtercontent(for: textToBeLowercased!)
        
        DispatchQueue.main.async {
            
            self.listTableView.reloadData()
        }
    }
    
    // setting search UI
    func searchBarUI() {
           
    searchViewController.searchResultsUpdater = self
    searchViewController.hidesNavigationBarDuringPresentation = true
    searchViewController.searchBar.placeholder = "Search by movie name"
    searchViewController.searchBar.barTintColor = UIColor.yellow
    searchViewController.obscuresBackgroundDuringPresentation = false
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchViewController
        
    }
    
    // filtering search results
    func filtercontent(for searchText: String) {
        
    searchResults = self.rootViewModel.allMovies.filter({ (connect) -> Bool in
            
        return connect.title?.lowercased().range(of: searchText) != nil
            
        })
      }
     }

// MARK: TableView Aspects - VC Extension

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchViewController.isActive {
            
            return searchResults.count
            
        } else {
            
            return rootViewModel.allMovies.count
            
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listTableView.dequeueReusableCell(withIdentifier: Properties.tableCellID, for: indexPath) as! MovieListTableViewCell
        
       
        if searchViewController.isActive {
            
            cell.movieList = searchResults[indexPath.row]
            
            
        } else {
            
            cell.movieList = rootViewModel.allMovies[indexPath.row]
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
    let label = UILabel()
        label.frame = CGRect.init(x: 3, y: 3, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Most Popular"
        label.font = label.font.withSize(17)
        label.textColor = UIColor.white
        label.backgroundColor = .black
        label.textAlignment = .left
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        headerView.addSubview(label)

        return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            return 40
        
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: Properties.movieDetailVC) as! MovieDetailViewController
        
        if searchViewController.isActive {
            
            nextVC.movieIDPassedOver = searchResults[indexPath.row].id
            
        } else {
            
            nextVC.movieIDPassedOver = rootViewModel.allMovies[indexPath.row].id

        }
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
   }

// MARK: CollectionView Aspects - VC Extension

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return rootViewModel.movieList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: Properties.collectionCellID, for: indexPath) as! MovieListCollectionViewCell
        
        cell.moviePictures = rootViewModel.movieList[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize.init(width: view.frame.width, height: view.frame.height * 0.35)
        
        }
    
}
