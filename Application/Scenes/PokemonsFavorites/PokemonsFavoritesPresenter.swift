import Foundation

protocol PokemonFavoritesPresentationLogic {
    func presentFetchPokemons(response: PokemonFavorites.FetchPokemons.Response)
}

class PokemonFavoritesPresenter {
    weak var displayLogic: PokemonFavoritesDisplayLogic?
}

// MARK: - PokemonListPresentationLogic
extension PokemonFavoritesPresenter: PokemonFavoritesPresentationLogic {
    func presentFetchPokemons(response: PokemonFavorites.FetchPokemons.Response) {
        let formattedResponse = format(response)
        let viewModel = PokemonList.FetchPokemons.ViewModel(pokemons: formattedResponse)
        displayLogic?.displayFetchPokemons(viewModel: viewModel)
    }
    
    private func format(_ response: PokemonFavorites.FetchPokemons.Response) -> [DisplayedPokemon]? {
        return response.pokemons?.map { DisplayedPokemon(firstType: $0.types.first?.type.name ?? "",
                                                         secType: $0.types.count == 1 ? nil : $0.types.last?.type.name,
                                                         image: $0.sprites.frontDefault,
                                                         name: $0.name.replacingOccurrences(of: "-", with: " ").capitalized) }
    }
}

