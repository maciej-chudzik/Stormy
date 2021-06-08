//
//  WeeklyWeatherTableVC.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class WeeklyWeatherTableVC: UITableViewController{
    
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentCityLabel: UILabel!
    
    var clCoordinator: CoreLocationCoordinator?
    
    var weeklyWeather =  [DayData]()
    var daysTime: [Int]?
    var coordinates: (Double, Double)?
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.clCoordinator = CoreLocationCoordinator(completion: { coordinates in
            self.retrieveNormalForecast(coordinates: coordinates)
        })
        
        configureTableView()
        configureNavigationController()
        
    }
    
    func configureTableView(){
        tableView.backgroundView = BackgroundView()
        tableView.rowHeight = 64
    }
    
    func configureNavigationController(){
        
        
        navigationController?.navigationBar.setBarColor(UIColor.clear)
        navigationController?.navigationBar.isHidden = false
        
    }
    
    func setUpAndPresentGMS(){
        
        GMSPlacesClient.provideAPIKey(PlistReader.sharedInstance.getValue(nameOfFile: "APIkeys", nameOfKey: "GMS") as! String)
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.tableCellBackgroundColor = darkPurple
        autocompleteController.tintColor = darkPurple
        autocompleteController.primaryTextColor = .white
        
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func addPlace(_ sender: Any) {
        
        setUpAndPresentGMS()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weeklyWeather.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekdayCell", for: indexPath as IndexPath) as! DailyWeatherTableViewCell
        
        let dailyWeather = weeklyWeather[indexPath.row]
        
        if let temp = dailyWeather.temperatureMax{
            
            cell.temperatureLabel.text = "\(Int(temp))\(UnitsConverter.determineUnitType(source: .temperature))°"}
        
        
        cell.weatherIcon.image = UIImage(named: dailyWeather.icon!)
        
        cell.dayLabel.text = UnitsConverter.dayStringFromUnixTime(Double(dailyWeather.time!), countryCode: Locale.current.regionCode!).capitalizingFirstLetter()
        cell.dateLabel.text = UnitsConverter.dayMonthStringFromUnixTime(Double(dailyWeather.time!), countryCode: Locale.current.regionCode!)
        
        
        return cell
    }
    
    
    @IBAction func refreshWeather() {
        
        let refreshControl = self.refreshControl as! LightningRefreshControl
        
        refreshControl.nvActivityIndicator?.startAnimating()
        
        clCoordinator?.getLocationData(completion: { coordinates in
        
            self.retrieveNormalForecast(coordinates: coordinates)
            
            DispatchQueue.main.async {
                
                refreshControl.nvActivityIndicator?.stopAnimating()
                
                self.refreshControl?.endRefreshing()
                
            }
        })
        
    }
    
    
    
    private func retrieveNormalForecast(coordinates: CLLocation){
        
        self.coordinates = (coordinates.coordinate.latitude, coordinates.coordinate.longitude)
        
        self.clCoordinator?.getPlaceMarkAndCountryCode(coordinates, completion: { placemark, countryCode in
            
            var code: String
            
            if Locale.current.regionCode == "US"{
                code = "EN"
            }else{
                
                code = Locale.current.regionCode!
            }
            
            
            APIClient().request(apicall: APIWeatherRequests.getNormalForcast(query_parameters: [URLQueryItem(name: "lang", value: code), URLQueryItem(name: "units", value: UnitsConverter.determineUnitSystem())], coordinates: (latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude)), completion: { normalWeather in
                
                
                self.weeklyWeather = normalWeather.daily!.data!
                self.daysTime = self.weeklyWeather.map{ $0.time!}
                
                
                DispatchQueue.main.async {
                    
                    self.title = "\(UnitsConverter.dayMonthStringFromUnixTime(Double(self.daysTime!.first!), countryCode: code)) - \(UnitsConverter.dayMonthStringFromUnixTime(Double(self.daysTime!.last!), countryCode: code))"
                    
                    
                    if let temperature = normalWeather.currently!.temperature {
                        self.currentTemperatureLabel?.text = "\(Int(temperature))\(UnitsConverter.determineUnitType(source: .temperature))º"
                    }
                    
                    if let iconString = normalWeather.currently!.icon {
                        
                        self.currentWeatherIcon?.image = UIImage(named: iconString)
                    }
                    
                    self.currentCityLabel?.text = "\(String(describing: placemark!.locality!))"
                    
                    
                    self.tableView.reloadData()
                }
            })
            
        })
    }
    
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        cell?.selectedBackgroundView = highlightView
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "hourly"{
            
            
            let hourlyVC = segue.destination as! HourlyWeatherVC
            
            hourlyVC.coordinates = self.coordinates
            hourlyVC.dayTime = self.daysTime![self.tableView.indexPathForSelectedRow!.row]
            
            
        }
        
    }
}

extension WeeklyWeatherTableVC: GMSAutocompleteViewControllerDelegate {

  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
    self.coordinates = (place.coordinate.latitude, place.coordinate.longitude)
    self.retrieveNormalForecast(coordinates: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
   
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    
    print("Error: ", error.localizedDescription)
  }


  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }


}
