//
//  CarFitManager.swift
//  CarFit
//
//  Created by Mallu on 19/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit

class CarFitManager: NSObject {

    //MARK:- Shared method to get data from static json file
    static func getDataFromJson(fileName: String) -> Data?{
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }
}
