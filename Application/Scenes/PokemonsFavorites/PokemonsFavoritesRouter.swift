import Foundation
import UIKit

typealias PokemonFavoritesRouterLogic =  (PokemonFavoritesRoutingLogic & PokemonFavoritesDataPassing)?

protocol PokemonFavoritesRoutingLogic {
    func routeToPokemonDetail()
}

protocol PokemonFavoritesDataPassing {
    var dataStore: PokemonFavoritesDataStore? { get }
}

final class PokemonFavoritesRouter: PokemonFavoritesDataPassing {
    weak var viewController: PokemonFavoritesViewController?
    weak var pokemonDetailFactory: PokemonDetailFactory!
    var dataStore: PokemonFavoritesDataStore?
}

// MARK: - PokemonFavoritesRoutingLogic
extension PokemonFavoritesRouter: PokemonFavoritesRoutingLogic {
    func routeToPokemonDetail() {
        let destinationVC = pokemonDetailFactory.makePokemonDetailViewController() as! PokemonDetailViewController
        var destinationDataStore = destinationVC.router?.dataStore
        passDataToDetailPokemon(source: dataStore!, destination: &destinationDataStore!)
        navigateToDetailPokemon(source: viewController, destination: destinationVC)
    }
    
    func navigateToDetailPokemon(source: PokemonFavoritesViewController?, destination: UIViewController) {
        DispatchQueue.main.async { [weak source] in
            source?.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func passDataToDetailPokemon(source: PokemonFavoritesDataStore, destination: inout PokemonDetailDataStore) {
        let selectedRow = viewController?.viewLogic.getSelectedRow()
        destination.pokemon = source.pokemons[selectedRow!]
    }
    
}

