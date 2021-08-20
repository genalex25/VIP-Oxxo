import Foundation
import UIKit
import UI

protocol PokemonDetailDisplayLogic: class {
    func displayPokemonDetail(viewModel: PokemonDetail.PokemonDetail.ViewModel)
    func displayPokemonAbout(viewModel: PokemonDetail.About.ViewModel)
    func displayFavoritePokemon(viewModel: PokemonDetail.FavoritePokemon.ViewModel)
}

class PokemonDetailViewController: UIViewController {
    let interactor: PokemonDetailBusinessLogic
    let router: PokemonDetailRouterLogic
    var viewLogic: PokemonDetailViewLogic
    
    init(viewLogic: PokemonDetailViewLogic,
         interactor: PokemonDetailBusinessLogic,
         router: PokemonDetailRouterLogic) {
        self.viewLogic = viewLogic
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigation = self.navigationController{
            navigation.isNavigationBarHidden = true
        }
        interactor.fetchPokemonDetail(request: PokemonDetail.PokemonDetail.Request())
        interactor.fetchPokemonAbout(request: PokemonDetail.About.Request())
    }
}

// MARK: - PokemonDetailDisplayLogic
extension PokemonDetailViewController: PokemonDetailDisplayLogic {
    func displayPokemonDetail(viewModel: PokemonDetail.PokemonDetail.ViewModel) {
        viewLogic.set(viewModel: PokemonDetailViewModel(name: viewModel.pokemon.name,
                                                        image: viewModel.pokemon.detailImage,
                                                        favorited: viewModel.pokemon.favorited,
                                                        firstType: viewModel.pokemon.firstType,
                                                        secType: viewModel.pokemon.secType,
                                                        order: viewModel.pokemon.order))
    }
    
    func displayPokemonAbout(viewModel: PokemonDetail.About.ViewModel) {
        viewLogic.set(about: AboutPropertyViewModel(height: viewModel.height, weight: viewModel.weight))
    }
    
    func displayFavoritePokemon(viewModel: PokemonDetail.FavoritePokemon.ViewModel) {
        self.viewLogic.set(favorite: viewModel.favorite, success: viewModel.success)
        shouldShowErrorAlert(success: viewModel.success)
    }
}

// MARK: - UI Events
extension PokemonDetailViewController: PokemonDetailDelegate {
    func set(imageView: UIImageView?, with url: String) {
        imageView?.setImage(with: url, placeholder: nil)
    }
    
    func didTapBackButton() {
        router?.popViewController()
    }
    
    func didTapFavorite() {
        interactor.fetchFavoritePokemon(request: PokemonDetail.FavoritePokemon.Request())
    }

    func didTapAbout() {
        interactor.fetchPokemonAbout(request: PokemonDetail.About.Request())
    }
}

// MARK: - Helper Methods
extension PokemonDetailViewController {
    private func shouldShowErrorAlert(success: Bool) {
        guard !success else { return }
        showAlert(title: "Error", message: "An error occurred while saving 😭")
    }
}
