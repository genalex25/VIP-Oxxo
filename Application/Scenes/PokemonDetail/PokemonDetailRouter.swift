import Foundation
import UIKit

typealias PokemonDetailRouterLogic = (PokemonDetailRoutingLogic & PokemonDetailDataPassing)?

protocol PokemonDetailRoutingLogic {
    func popViewController()
    //func routeToPropertyDetail(type: PropertyDetailType)
}

protocol PokemonDetailDataPassing {
    var dataStore: PokemonDetailDataStore? { get }
}

class PokemonDetailRouter: PokemonDetailDataPassing {
    weak var viewController: PokemonDetailViewController?
    //weak var propertyDetailFactory: PropertyDetailFactory!
    var dataStore: PokemonDetailDataStore?
}

extension PokemonDetailRouter: PokemonDetailRoutingLogic {
    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToDetailPokemon(source: PokemonDetailViewController?, destination: UIViewController) {
        DispatchQueue.main.async { [weak source] in
            source?.present(destination, animated: true, completion: nil)
        }
    }
}

