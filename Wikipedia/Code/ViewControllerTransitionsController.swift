import UIKit

@objc(WMFViewControllerTransitionsController)
class ViewControllerTransitionsController: NSObject, UINavigationControllerDelegate {
    @objc func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let searchController = searchAnimationController(for: operation, from: fromVC, to: toVC) {
            return searchController
        }
        
        if let imageController = imageScaleAnimationController(for: operation, from: fromVC, to: toVC) {
            return imageController
        }
       
        return nil
    }
    
    
    private func searchAnimationController(for operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let exploreVC = fromVC as? ExploreViewController ?? toVC as? ExploreViewController,
            exploreVC.wantsCustomSearchTransition
            else {
                let searchVC = toVC as? SearchViewController ?? fromVC as? SearchViewController
                searchVC?.shouldAnimateSearchBar = false // disable search bar animation on standard push
                return nil
        }
        
        if let searchVC = toVC as? SearchViewController {
            return SearchTransition(searchViewController: searchVC, exploreViewController: exploreVC, isEnteringSearch: true)
        } else if let searchVC = fromVC as? SearchViewController  {
            return SearchTransition(searchViewController: searchVC, exploreViewController: exploreVC, isEnteringSearch: false)
        }
        
        return nil
    }
    
    private func imageScaleAnimationController(for operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let source = toVC as? ImageScaleTransitionSourceProviding ?? fromVC as? ImageScaleTransitionSourceProviding,
            let destination = fromVC as? ImageScaleTransitionDestinationProviding ?? toVC as? ImageScaleTransitionDestinationProviding else {

                return nil
        }
        return ImageScaleTransitionController(source: source, destination: destination)
    }
    
    @objc func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
