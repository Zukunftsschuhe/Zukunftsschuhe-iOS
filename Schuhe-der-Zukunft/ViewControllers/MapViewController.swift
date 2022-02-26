import Foundation
import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import MapboxMaps
import MapboxSearchUI
import MapboxSearch
import CoreLocation


public var zielKoordinaten = CLLocationCoordinate2D(latitude: 0.0000, longitude: 0.0000)

class MapViewController: MapsViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var jetztNavigierenButton: UIButton!
    
    
    lazy var searchController: MapboxSearchController = {
        let locationProvider = PointLocationProvider(coordinate: .biberach)
        var configuration = Configuration(locationProvider: locationProvider)
        
        return MapboxSearchController(configuration: configuration)
    }()
    
    lazy var panelController = MapboxPanelController(rootViewController: searchController)
    
    
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let standortWert: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Eigener Standort: \(standortWert.latitude) \(standortWert.longitude)")

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        jetztNavigierenButton.isHidden = true
        let cameraOptions = CameraOptions(center: .biberach, zoom: 15)
        mapView.camera.fly(to: cameraOptions, duration: 1, completion: nil)
        
        searchController.delegate = self
        addChild(panelController)
        locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {}
    }
    
    @IBAction func jetztNavigierenButton_tapped(_ sender: UIButton) {
    setUpElements()
   let origin = CLLocationCoordinate2D(latitude: 48.10925799914662, longitude: 9.796569144597571)
            let destination = zielKoordinaten
            let options = NavigationRouteOptions(coordinates: [origin, destination])
            
            Directions.shared.calculate(options) { [weak self] (_, result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let response):
                    guard let strongSelf = self else {
                        return
                    }
                    
                    // For demonstration purposes, simulate locations if the Simulate Navigation option is on.
                    // Since first route is retrieved from response `routeIndex` is set to 0.
                    let navigationService = MapboxNavigationService(routeResponse: response, routeIndex: 0, routeOptions: options, simulating: simulationIsEnabled ? .always : .onPoorGPS)
                    let navigationOptions = NavigationOptions(navigationService: navigationService)
                    let navigationViewController = NavigationViewController(for: response, routeIndex: 0, routeOptions: options, navigationOptions: navigationOptions)
                    navigationViewController.modalPresentationStyle = .fullScreen
                    // Render part of the route that has been traversed with full transparency, to give the illusion of a disappearing route.
                    navigationViewController.routeLineTracksTraversal = true
                    
                    strongSelf.present(navigationViewController, animated: true, completion: nil)
                
            }
            
        }
        jetztNavigierenButton.isHidden = true
    }
    
 
    func showButton() {
        jetztNavigierenButton.isHidden = false
        jetztNavigierenButton.isEnabled = true
        
    }
    
}



extension MapViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult]) {
        showAnnotations(results: results)
        //print(results)
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        showAnnotation(searchResult)
        print("Koordinaten !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        zielKoordinaten = searchResult.coordinate
        print(zielKoordinaten)
        showButton()
        
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotation(userFavorite)
    }

    func setUpElements() {
        Utilities.styleFilledButton(jetztNavigierenButton)
        
    }

}


