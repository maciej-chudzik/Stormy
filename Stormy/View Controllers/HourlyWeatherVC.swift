//
//  HourlyVC.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import UIKit
import GraphSketcher



class HourlyWeatherVC: UIViewController {
    
    
    @IBOutlet weak var graphImageView: GraphImageView!
    @IBOutlet weak var weatherDataScrollView: WeatherDataScrollView!
    @IBOutlet weak var weatherDataIcon: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var moonPhaseLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var moonPhaseImageView: UIImageView!
    @IBOutlet weak var windBearingImageView: WindBearingIconImageView!
    @IBOutlet weak var windBearingLabel: UILabel!
    @IBOutlet weak var windSpeedImageView: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var cloudCoverImageView: UIImageView!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityImageView: UIImageView!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var uvIndexImageView: UIImageView!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var segementedSelectionView: MultiSelectSegmentedControl!
    
    
    

    var hourlyWeather: [HourData]?
    var dailyWeather: DailyTimeMachine?
   
    
    var dayTime: Int?
    var coordinates: (latitude: Double, longitude: Double)?
    var graphs = GraphArray()
    var graphSketcher: GraphSketcher?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBarColor(UIColor.clear)
        self.navigationController?.navigationBar.isHidden = false
        self.title = UnitsConverter.dayStringFromUnixTime(Double(dayTime!), countryCode: Locale.current.regionCode!).capitalizingFirstLetter()
        
        configureGraphSketcher()
        retrieveTimeMachineForecast()
        configureSegementedSelectionView()
        
    }
    
    
    
    private func configureSegementedSelectionView(){
        
        segementedSelectionView.delegate = self
        setSegmentsForGraphs(fields: [.temperature, .apparentTemperature])
        segementedSelectionView.selectedSegmentIndex = 1
        
        
        
    }
    
    private func configureGraphSketcher(){
        
        graphSketcher = GraphSketcher(drawOn: self.graphImageView.bounds, xMargin: self.graphImageView.bounds.height/5, yMargin: self.graphImageView.bounds.height/5)
        
    }
    

    
    @IBAction func refresh(_ sender: Any) {
        retrieveTimeMachineForecast()
        
    }
    
    
    private func setSegmentsForGraphs(fields: [HourDataOption]){
        
        segementedSelectionView.items = fields.map{$0.rawValue}
        
        
    }
    

    private func setGraphsForChosenSements(hourlyWeather: [HourData]){
        
        for graphSegment in self.segementedSelectionView.items{
            
            var tempArray = [Int]()
            
            for hourData in hourlyWeather{
                
                let propertyValue = hourData.getPropertyValue(filter: graphSegment as! String)
                
                if let castedInt = propertyValue as? Int{
                    
                    tempArray.append(castedInt)
                    
                }else if let castedDouble = propertyValue as? Double{
                    
                    tempArray.append(Int(castedDouble))
                }
                
                
                
            }
            
            let graph = Graph(name: graphSegment as! String, values: tempArray)
            
            self.graphs.add(graph, withMode: GraphDrawingMode(drawingMode: .strokeAndFill(strokecolor: UIColor.white, fillcolor: UIColor.white, width: 1.0), withBoldedPoints: true))
            
        }
    }
    
    
    func retrieveTimeMachineForecast(){
        
        
        guard let coordinates = coordinates, let dayTime =  dayTime else {return}
        
        var code: String
        
        if Locale.current.regionCode == "US"{
            code = "EN"
        }else{
            
            code = Locale.current.regionCode!
        }
        
        APIClient().request(apicall: APIWeatherRequests.getTimeMachineForcast(query_parameters: [URLQueryItem(name: "lang", value: code), URLQueryItem(name: "units", value: UnitsConverter.determineUnitSystem())], coordinates: coordinates, time: dayTime), completion: { timeMachineWeather in
            
            guard let hourlyWeather = timeMachineWeather.hourly?.data, let dailyWeather = timeMachineWeather.daily else {return}
            
            self.hourlyWeather = hourlyWeather
            self.dailyWeather  = dailyWeather
            
            
            DispatchQueue.main.async {
                
                self.setGraphsForChosenSements(hourlyWeather: hourlyWeather)
                let selectedSegments =  self.getSelectedSegementsLabels()
                
                let graphsToDraw = self.graphs.graphsWithNames(names: selectedSegments)
                
                let hours = hourlyWeather.map{UnitsConverter.hourStringFromUnixTime(Double($0.time!), countryCode: code)}
                    
                
                self.graphSketcher!.setGraphsToDraw(graphs: graphsToDraw!)!
                    
                    .setCountAxis(options:.withDivisionLines(.withLabels(onSide: .right, .withOwnSource(labels: hours))), mode: .stroke(color: UIColor.white, width: 1.0), arrowed: true, keyPointsOption: .marked(mode: .dashedStroke(strokecolor: UIColor.white, width: 1.0, phase: 5.0, pattern: [5.0, 5.0])), axisLabel: "h")!

                    .setValueAxis(options:.withDivisionLines(.withLabels(onSide: .left, .typeSource)), mode: .stroke(color: UIColor.white, width: 1.0), arrowed: true, keyPointsOption: .marked(mode: .dashedStroke(strokecolor: UIColor.white, width: 1.0, phase: 5.0, pattern: [5.0, 5.0])), axisLabel: "\(UnitsConverter.determineUnitType(source: .temperature))º")
                
                self.graphImageView.image = self.graphSketcher!.renderImage()
                
                
                if let dailyDayData = dailyWeather.data?.first{
                    
                    if let moonPhaseData = dailyDayData.moonPhase{
                        
                        
                        let moonPhaseIconSketcher = IconSketcher(drawOn: self.moonPhaseImageView.bounds, option: .withAdditionalAreas(xMargin: 10.0, yMargin: 10.0))
                        
                        let _ = moonPhaseIconSketcher!.drawMoonIcon(mode: .strokeAndFill(strokecolor: UIColor.white, fillcolor: UIColor.white,  width: 2.0), moonPhaseData: moonPhaseData)
                        
                        self.moonPhaseImageView.image =  moonPhaseIconSketcher!.renderImage()
                        
                        self.moonPhaseLabel.text = Moon.determinePhaseName(moonPhaseData: moonPhaseData)
                    }
                    
                    if let windBearing = dailyDayData.windBearing{
                        
                        
                        let windBearingIconSketcher = IconSketcher(drawOn: self.windBearingImageView.bounds, option: .withAdditionalAreas(xMargin: 10.0, yMargin: 10.0))
                        
                        self.windBearingImageView.image =  windBearingIconSketcher?.drawWindDirectionIcon(mode: .stroke(color: UIColor.white, width: 2.0), windBearing: windBearing).renderImage()
                        
                        
                        self.windBearingLabel.text = Wind.determineWindDirection(windBearing: windBearing)
                        
                        
                    }
                    
                    
                    if let iconString = dailyDayData.icon{
                        
                        self.weatherDataIcon.image = UIImage(named: iconString)
                    }
                    
                    if let summary = dailyDayData.summary{
                        
                        self.summaryLabel.text = summary
                    }
                    
                    if let sunriseTime = dailyDayData.sunriseTime{
                        
                        self.sunriseTimeLabel.text = UnitsConverter.hoursMinutesStringFromUnixTime(Double(sunriseTime))
                    }
                    
                    if let sunsetTime = dailyDayData.sunsetTime{
                        
                        self.sunsetTimeLabel.text = UnitsConverter.hoursMinutesStringFromUnixTime(Double(sunsetTime))
                    }
                    
                   
                    
                    if let pressure = dailyDayData.pressure{
                        
                        self.pressureLabel.text = "\(Int(pressure))\(UnitsConverter.determineUnitType(source: .atmPressure))"
                    }
                    
                    
                    if let windspeed = dailyDayData.windSpeed{
                        
                        self.windSpeedLabel.text = "\(Int(windspeed))\(UnitsConverter.determineUnitType(source: .windSpeed))"
                    }
                    
                    if let cloudCover = dailyDayData.cloudCover{
                        
                        self.cloudCoverLabel.text = String(Int(cloudCover * 100)) + " %"
                        
                    }
                    
                    if let humidity = dailyDayData.humidity{
                        
                        self.humidityLabel.text = String(Int(humidity * 100)) + " %"
                        
                    }
                    
                    if let visibility = dailyDayData.visibility{
                        
                        self.visibilityLabel.text = "\(Int(visibility))\(UnitsConverter.determineUnitType(source: .visibility))"
                        
                    }
                    
                    if let uvIndex = dailyDayData.uvIndex{
                        
                        
                        let uvIndexIconSketcher = IconSketcher(drawOn: self.uvIndexImageView.bounds, option: .withAdditionalAreas(xMargin: 10.0, yMargin: 10.0))
                        
                        let _ = uvIndexIconSketcher!.drawUVIndexIcon(mode: .stroke(color: UIColor.white, width: 2.0))
                        
                        self.uvIndexImageView.image = uvIndexIconSketcher!.renderImage()
                        
                        self.uvIndexLabel.text = String(uvIndex)
                    }
                    
                }
                
            }
            
            
        })
        
    }
    
    private func getSelectedSegementsLabels() -> [String]{
        
        return segementedSelectionView.segments.filter{$0.isSelected}.map{$0.label!.text!}
    }

}


extension HourlyWeatherVC: MultiSelectSegmentedControlDelegate {
    
    func multiSelect(_ multiSelectSegmentedControl: MultiSelectSegmentedControl, didChange value: Bool, at index: Int) {
        
        
        let selectedSegments =  getSelectedSegementsLabels()
        
        guard !selectedSegments.isEmpty else {
            
            let rollup = viewsAnimations.rollUp(duration: 0.1, delayFactor: 0)
            let animator = ViewsAnimator(animation: rollup)
            animator.animateView(view: self.graphImageView)
            
            return
            
        }
        
        let graphsToDraw = self.graphs.graphsWithNames(names: selectedSegments)
        
        if selectedSegments.count != multiSelectSegmentedControl.segments.count{
            
            if self.graphImageView.zeroHeightConstraint != nil{
                
                
                let rollup = viewsAnimations.rollUp(duration: 0.1, delayFactor: 0)
                let animator = ViewsAnimator(animation: rollup)
                animator.animateView(view: self.graphImageView)
                
            }
        }
        
        
        graphSketcher!.setGraphsToDraw(graphs: graphsToDraw!)!
            
            .setCountAxis(options:.withDivisionLines(.withLabels(onSide: .right, .typeSource)), mode: .stroke(color: UIColor.white, width: 1.0), arrowed: true, keyPointsOption: .marked(mode: .dashedStroke(strokecolor: UIColor.white, width: 1.0, phase: 5.0, pattern: [5.0, 5.0])))!
            
            .setValueAxis(options:.withDivisionLines(.withLabels(onSide: .left, .typeSource)), mode: .stroke(color: UIColor.white, width: 1.0), arrowed: true, keyPointsOption: .marked(mode: .dashedStroke(strokecolor: UIColor.white, width: 1.0, phase: 5.0, pattern: [5.0, 5.0])))
        
        self.graphImageView.image = graphSketcher!.renderImage()

        
    }

}
    

    


