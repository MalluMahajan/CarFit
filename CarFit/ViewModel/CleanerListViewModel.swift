//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Mallu on 19/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit
import CoreLocation

class CleanerListViewModel: NSObject {

    var onErrorHandling : ((ErrorResult) -> Void)?
    var arrayCarWasherVisits = [CarWashVisit]()
    var filteredArrayCarWasherVisits = [CarWashVisit]()
    typealias CompletionHandler = () -> Void
    
    override init() {
        super.init()
        self.getJsonData()
    }
    //MARK:- Get data form json or api
    func getJsonData(){
        guard let data = CarFitManager.getDataFromJson(fileName: "carfit") else{
            onErrorHandling?(ErrorResult.custom(string: "Missing file"))
            return
        }
        do {
            let carWasherModel = try JSONDecoder().decode(CarWasherModel.self, from: data)
            self.arrayCarWasherVisits = carWasherModel.data
        } catch {
            onErrorHandling?(ErrorResult.custom(string: "Missing file"))
        }
    }
    //MARK:- Filter CarWasherVisits list based on selected dates
    func filterCarWasherVisits(selectedDates: [String], completionHandler: CompletionHandler) {
        self.filteredArrayCarWasherVisits.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormatType.apiDateFormat.rawValue
        for selectedDate in selectedDates{
            let filteredData = self.arrayCarWasherVisits.filter( {
                let date = dateFormatter.date(from: $0.startTimeUtc ?? "" ) ?? Date()
                return date.toString(format: .simpleDateFormat) ==  selectedDate})
            self.filteredArrayCarWasherVisits.append(contentsOf: filteredData)
        }
        //Sort the list data to calculate the distance from previous visited location
        self.filteredArrayCarWasherVisits.sort(by: { (dateFormatter.date(from: $0.startTimeUtc ?? "") ?? Date()).compare(dateFormatter.date(from: $1.startTimeUtc ?? "") ?? Date()) == .orderedAscending })
        completionHandler()
    }
    //MARK:- Set CarWashersVisters list title in navigation bar
    func setTitle(arrayDatesSelected: [String]) -> String{
        switch arrayDatesSelected.count{
        case 0:
            return ""
        case 1:
            return arrayDatesSelected.joined(separator: ", ")
        default:
            return "Result for \(arrayDatesSelected.count) days"
        }
    }
}
//MARK:- CarWasherVisitViewModel for CarWasherVisits listing
class CarWasherVisitViewModel: NSObject {
      var carWasherVisit: CarWashVisit
      var previousCarWasherVisit: CarWashVisit?
      
      init(carWasherVisit: CarWashVisit, previousCarWasherVisit: CarWashVisit?) {
          self.carWasherVisit = carWasherVisit
          self.previousCarWasherVisit = previousCarWasherVisit
      }
      var name: String {
          var name = ""
          if let firstName = carWasherVisit.houseOwnerFirstName {
              name = firstName
          }
          if let lastName = carWasherVisit.houseOwnerLastName {
              name += " " + lastName
          }
          return name
      }
      var destinationAddress: String{
          var destinationAddress = ""
          if let address = carWasherVisit.houseOwnerAddress{
              destinationAddress = address
          }
          if let zip = carWasherVisit.houseOwnerZip{
              destinationAddress += " " + zip
          }
          if let city = carWasherVisit.houseOwnerCity{
              destinationAddress += " " + city
          }
          return destinationAddress
      }
      var arrivalTime: String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = Date.DateFormatType.apiDateFormat.rawValue
          guard let startTime = dateFormatter.date(from: carWasherVisit.startTimeUtc ?? ""), let expectedTime = carWasherVisit.expectedTime else {return "No value"}
          return "\(startTime.toString(format: Date.DateFormatType.timeDateFormat))/\(expectedTime.replacingOccurrences(of: "/", with: "-"))"
      }
      var distance: String{
        //Get distance from previous visit address, if no previous visit then set 0 Km
          guard let previousCarWasherLatitude = previousCarWasherVisit?.houseOwnerLatitude, let previousCarWasherLongitude = previousCarWasherVisit?.houseOwnerLongitude, let carWasherLatitude = carWasherVisit.houseOwnerLatitude, let carWasherLongitude = carWasherVisit.houseOwnerLongitude else{
              return "0 Km"
          }
          let previousLocation = CLLocation(latitude: previousCarWasherLatitude, longitude: previousCarWasherLongitude)
          let newLocation = CLLocation(latitude: carWasherLatitude, longitude: carWasherLongitude)
          return "\(String(format: "%.2f", (previousLocation.distance(from: newLocation)/1000))) Km"
       
      }
      var tasks: String{
          if let carWasherTasks = carWasherVisit.tasks {
            let arrTasks = carWasherTasks.map { $0.title ?? ""}
            return arrTasks.joined(separator: ", ")
          }else{
              return ""
          }
      }
      var timeRequired: String{
        //Get sum of each task time in minutes if no tasks data then set 0 min
          if let carWasherTasks = carWasherVisit.tasks {
              var sum = 0
              carWasherTasks.forEach { sum += $0.timesInMinutes ?? 0 }
              return "\(sum) min"
          }else{
              return "0 min"
          }
      }
      var status: String{
          return carWasherVisit.visitState ?? ""
      }
      var state: VisitState?{
          return VisitState(rawValue: carWasherVisit.visitState ?? "")
      }
  }

