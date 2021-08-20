import Foundation
import Data
import Domain
import UI
import UIKit

public typealias SceneFactory = PokemonDetailFactory & PokemonListFactory & PokemonListFavoritesFactory

public protocol PokemonDetailFactory: class {
    func makePokemonDetailViewController() -> UIViewController
}
public protocol PokemonListFactory: class {
    func makePokemonListViewController() -> UIViewController
}

public protocol PokemonListFavoritesFactory: class {
    func makePokemonFavoritesViewController() -> UIViewController
}


public class Main: SceneFactory {
    
    let client: HttpClient
    let requestObject: RequestObject
    
    public init(client: HttpClient,
                requestObject: RequestObject) {
        self.client = client
        self.requestObject = requestObject
    }
    
    public func makePokemonListViewController() -> UIViewController {
        let presenter = PokemonListPresenter()
        let router = PokemonListRouter()
        let interactor = PokemonListInteractor(fetchPokemons: makeRemoteFetchPokemonsUseCase())
        let view = PokemonListView()
        let viewController = PokemonListViewController(viewLogic: view, interactor: interactor, router: router)
        
        view.delegate = viewController
        presenter.displayLogic = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        router.dataStore = interactor
        router.pokemonDetailFactory = self
        router.pokemonFavoriteFactory = self
        
    
        
        return viewController
    }

    public func makePokemonDetailViewController() -> UIViewController {
        let presenter = PokemonDetailPresenter()
        let router = PokemonDetailRouter()
        let interactor = PokemonDetailInteractor(remoteFavorite: makeRemoteFavoritePokemonUseCase(), localFavorite: makeLocalFavoritePokemonUseCase())
        let view = PokemonDetailView()
        let viewController = PokemonDetailViewController(viewLogic: view, interactor: interactor, router: router)
        
        view.delegate = viewController
        viewController.view = view
        presenter.displayLogic = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        router.dataStore = interactor
        //router.propertyDetailFactory = self
        
        
        
        return viewController
    }
    
    public func makePokemonFavoritesViewController() -> UIViewController {
        
           let presenter = PokemonFavoritesPresenter()
           let router = PokemonFavoritesRouter()
           let interactor = PokemonFavoritesInteractor(fetchPokemons: makeRemoteFetchPokemonsUseCase())
           let view = PokemonListView()
           let viewController = PokemonFavoritesViewController(viewLogic: view, interactor: interactor, router: router)
           
           view.delegate = viewController
           presenter.displayLogic = viewController
           interactor.presenter = presenter
           router.viewController = viewController
           router.dataStore = interactor
           router.pokemonDetailFactory = self
        
        
           
           return viewController
    }


    // MARK: - Helper Methods
    private func makeRemoteFetchPokemonsUseCase() -> FetchPokemons {
        let remoteFetchReferences = RemoteFetchReferences(client: requestObject)
        let remoteFetchAllPokemons = RemoteFetchAllPokemons(client: requestObject)
        return RemoteFetchPokemons(fetchReferences: remoteFetchReferences,
                                   fetchAllPokemons: remoteFetchAllPokemons)
    }


    private func makeFetchURLRemoteUseCase() -> FetchURLInfo {
        return RemoteFetchURLInfo(client: requestObject)
    }

    private func makeRemoteFavoritePokemonUseCase() -> FavoritePokemon {
        return RemoteFavoritePokemon(client: client)
    }
    
    private func makeLocalFavoritePokemonUseCase() -> LocalFavoritePokemon {
        return UserDefaultFavoritePokemon()
    }
}
