import UIKit
import MapKit

class TripDetails: UIViewController {
    
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblStartLocation: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewWeatherData: UIView!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblTemprature: UILabel!
    @IBOutlet weak var lblHumadity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var btnAddExpenses: UIButton!
    
    var trip: Trip?
    let weatherService = WeatherService()
    
    private var activityIndicator: UIActivityIndicatorView!
    private var activityBackgroundView: UIView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and customize the activity indicator
        setupActivityIndicator()
        
        // Display trip details, set UI elements, configure map view, and fetch weather data
        self.displayTripDetails()
        self.setUI()
        self.mapView.delegate = self
        
        // Safely show the route and fetch weather if trip is available
        if let trip = trip {
            showRouteOnMap()
            fetchWeatherForDestination()
        } else {
            print("Trip is nil, unable to show route or fetch weather")
        }
    }
    
    // MARK: - Setup Custom Activity Indicator
    
    func setupActivityIndicator() {
        // Create background view for activity indicator
        activityBackgroundView = UIView(frame: self.view.bounds)
        activityBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4) // Semi-transparent background
        activityBackgroundView.isHidden = true // Initially hidden
        
        // Initialize activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .accent  // Set the color of the spinner (foreground)
        activityIndicator.center = self.view.center
        
        // Add activity indicator to background view
        activityBackgroundView.addSubview(activityIndicator)
        
        // Add background view to the main view
        self.view.addSubview(activityBackgroundView)
    }
    
    // MARK: - Show Activity Indicator
    
    func showActivityIndicator() {
        activityBackgroundView.isHidden = false // Show background view
        activityIndicator.startAnimating() // Start the spinning animation
    }
    
    // MARK: - Hide Activity Indicator
    
    func hideActivityIndicator() {
        activityBackgroundView.isHidden = true // Hide background view
        activityIndicator.stopAnimating() // Stop the spinning animation
    }
    
    // MARK: - UI Setup Methods
    
    func setUI() {
        self.btnBack.layer.cornerRadius = self.btnBack.frame.height / 2
        self.mapView.layer.cornerRadius = 15
        self.viewWeatherData.layer.cornerRadius = 15
        self.btnAddExpenses.layer.cornerRadius = 15
    }
    
    /// Display the trip details on the UI.
    func displayTripDetails() {
        guard let trip = trip else { return }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        lblDestination.text = "Destination: \(trip.destination ?? "N/A")"
        lblStartLocation.text = "Starting Location: \(trip.startingLocation ?? "N/A")"
        
        if let startDate = trip.startDate {
            lblStartDate.text = "Start Date: \(formatter.string(from: startDate))"
        } else {
            lblStartDate.text = "Start Date: N/A"
        }
        
        if let endDate = trip.endDate {
            lblEndDate.text = "End Date: \(formatter.string(from: endDate))"
        } else {
            lblEndDate.text = "End Date: N/A"
        }
        
        // Add animation for the labels
        animateLabel(lblDestination)
        animateLabel(lblStartLocation)
        animateLabel(lblStartDate)
        animateLabel(lblEndDate)
    }
    
    func animateLabel(_ label: UILabel) {
        label.alpha = 0
        UIView.animate(withDuration: 1.0) {
            label.alpha = 1.0
        }
    }

    // MARK: - Action Methods
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddTripExpenses(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TripExpenses") as! TripExpenses
        vc.trip = trip
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Map Methods
    
    /// Show the route from the starting location to the destination on the map.
    func showRouteOnMap() {
        guard let trip = trip,
              let startLocation = trip.startingLocation,
              let destination = trip.destination else {
            print("Trip or locations are missing")
            return
        }
        
        // Show activity indicator before processing
        showActivityIndicator()
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(startLocation) { [weak self] (startPlacemarks, error) in
            guard let self = self, let startPlacemark = startPlacemarks?.first else {
                print("Error geocoding starting location: \(error?.localizedDescription ?? "Unknown error")")
                self?.hideActivityIndicator() // Stop activity indicator on error
                return
            }
            
            geocoder.geocodeAddressString(destination) { (destinationPlacemarks, error) in
                guard let destinationPlacemark = destinationPlacemarks?.first else {
                    print("Error geocoding destination: \(error?.localizedDescription ?? "Unknown error")")
                    self.hideActivityIndicator() // Stop activity indicator on error
                    return
                }
                
                let startMapItem = MKMapItem(placemark: MKPlacemark(placemark: startPlacemark))
                let destinationMapItem = MKMapItem(placemark: MKPlacemark(placemark: destinationPlacemark))
                
                let request = MKDirections.Request()
                request.source = startMapItem
                request.destination = destinationMapItem
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                directions.calculate { [weak self] (response, error) in
                    guard let self = self, let route = response?.routes.first else {
                        print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                        self?.hideActivityIndicator() // Stop activity indicator on error
                        return
                    }
                    
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                    
                    // Hide the activity indicator once the route is displayed
                    self.hideActivityIndicator()
                }
            }
        }
    }

    // MARK: - Weather Methods
    
    func fetchWeatherForDestination() {
        guard let trip = trip, let destination = trip.destination else {
            print("Trip or destination is missing")
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destination) { [weak self] (placemarks, error) in
            guard let self = self, let location = placemarks?.first?.location else {
                print("Error geocoding destination: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            self.weatherService.fetchWeather(latitude: latitude, longitude: longitude) { weatherData in
                guard let weatherData = weatherData else {
                    print("Failed to fetch weather data")
                    return
                }
                
                DispatchQueue.main.async {
                    let roundedTemp = Int(weatherData.main.temp)
                    let windSpeedKmh = weatherData.wind.speed * 3.6
                    
                    self.lblWeather.text = weatherData.weather.first?.description.capitalized
                    self.lblTemprature.text = "\(roundedTemp) °C"
                    self.lblHumadity.text = "Humidity: \(weatherData.main.humidity)%"
                    self.lblWind.text = String(format: "Wind Speed: %.1f km/h", windSpeedKmh)
                    
                    // Add animations for weather data
                    self.animateLabel(self.lblWeather)
                    self.animateLabel(self.lblTemprature)
                    self.animateLabel(self.lblHumadity)
                    self.animateLabel(self.lblWind)
                    
                    if let icon = weatherData.weather.first?.icon {
                        self.loadWeatherIcon(icon)
                    }
                }
            }
        }
    }
    
    func loadWeatherIcon(_ icon: String) {
        let iconURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        guard let url = URL(string: iconURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imgWeather.image = image
            }
        }
        task.resume()
    }
}

extension TripDetails: MKMapViewDelegate {
    // MARK: - MKMapViewDelegate Methods
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .accent
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}
