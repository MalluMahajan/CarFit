//
//  CarwashVisitModel.swift
//  CarFit
//
//  Created by Mallu on 19/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit

//MARK:- DataModel for CarWashVisits list
struct CarWasherModel: Codable {
    
    var success:Bool?
    var message:String?
    var data = [CarWashVisit]()
    var code:Int?
}
struct CarWashVisit: Codable {
    let houseOwnerFirstName: String?
    let houseOwnerLastName: String?
    let visitState: String?
    let startTimeUtc: String?
    let expectedTime: String?
    let houseOwnerAddress: String?
    let houseOwnerZip: String?
    let houseOwnerCity: String?
    let houseOwnerLatitude: Double?
    let houseOwnerLongitude: Double?
    let tasks: [Task]?
}
struct Task: Codable {
    let title: String?
    let timesInMinutes: Int?
}
enum VisitState: String {
    case toDo = "ToDo"
    case inProgress = "InProgress"
    case done = "Done"
    case rejected = "Rejected"
}
