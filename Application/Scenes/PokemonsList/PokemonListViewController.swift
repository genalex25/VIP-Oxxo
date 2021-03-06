import UIKit
import UI

protocol PokemonListDisplayLogic: class {
    func displayFetchPokemons(viewModel: PokemonList.FetchPokemons.ViewModel)
}

class PokemonListViewController: UIViewController {
    let interactor: PokemonListBusinessLogic
    let router: PokemonListRouterLogic
    
    var displayedPokemons = [DisplayedPokemon]()
    var viewLogic: PokemonListViewLogic
    
    // MARK: - Control
    var pagination: Int = 20
    var loading: Bool = true
    
    // MARK: - Life Cycle
    init(viewLogic: PokemonListViewLogic,
         interactor: PokemonListBusinessLogic,
         router: PokemonListRouterLogic) {
        self.viewLogic = viewLogic
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = viewLogic.view
    }
    
    override func viewDidLoad() {
        start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigation = self.navigationController{
            navigation.isNavigationBarHidden = false
        }
    }
    
    private func start() {
        startLoading()
        fetchPokemons()
        setFavButtonAndTitle()
    }
}

// MARK: - PokemonListDisplayLogic
extension PokemonListViewController: PokemonListDisplayLogic {
    func displayFetchPokemons(viewModel: PokemonList.FetchPokemons.ViewModel) {
        guard let pokemons = viewModel.pokemons else { return }
        viewLogic.set(viewModel: PokemonListViewModel(items: pokemons.map{ PokemonListItem(name: $0.name,
                                                                                           image: $0.image,
                                                                                           firstType: $0.firstType,
                                                                                           secType: $0.secType) }))
        stopLoading()
    }
}

// MARK: - PokemonListViewDelegate
extension PokemonListViewController: PokemonListViewDelegate {
    func set(imageView: UIImageView?, with url: String) {
        imageView?.setImage(with: url,placeholder: nil)
    }
    
    func isLoading() -> Bool {
        return self.loading
    }
    
    func reachedEndOfPage() {
        fetchNewPokemonPage()
    }
    
    func didSelectRow() {
        router?.routeToPokemonDetail()
    }
}

// MARK: - Helpers
extension PokemonListViewController {
    
    private func fetchPokemons() {
        interactor.fetchPokemons(request: PokemonList.FetchPokemons.Request(offset: pagination))
    }
    
    private func fetchNewPokemonPage() {
        self.startLoading()
        self.incrementPagination()
        self.fetchPokemons()
        debugPrint("Ask new page: \(self.pagination)")
    }
    
    private func incrementPagination() {
        self.pagination += 20
    }
    
    private func startLoading() {
        self.loading = true
    }
    
    private func stopLoading() {
        self.loading = false
    }
    
    private func setFavButtonAndTitle(){
        
       self.title = NSLocalizedString("WELCOME_TITLE", comment: "")
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites",
       style: .plain,
       target: self,
       action: #selector(goTofav))
        
        
    }
    
    @objc func goTofav(){
        router?.routeToFavorites()
    }
}
