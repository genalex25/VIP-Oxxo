import Foundation

public protocol PokemonDetailViewLogic: PropertiesViewBorder {
    var delegate: (PokemonDetailActionsDelegate)? { get set }
    func set(viewModel: PokemonDetailViewModel)
    func set(favorite: Bool, success: Bool)
}
