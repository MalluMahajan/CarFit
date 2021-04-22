//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    //MARK:- Configure CarWasherVisits Data in cell
    func setData(carWasherVisitVM: CarWasherVisitViewModel){
        self.customer.text = carWasherVisitVM.name
        self.destination.text = carWasherVisitVM.destinationAddress
        self.timeRequired.text = carWasherVisitVM.timeRequired
        self.distance.text = carWasherVisitVM.distance
        self.arrivalTime.text = carWasherVisitVM.arrivalTime
        self.tasks.text = carWasherVisitVM.tasks
        self.status.text = carWasherVisitVM.status
        switch  carWasherVisitVM.state{
        case .toDo:
            self.statusView.backgroundColor = UIColor.todoOption
            break;
        case .done:
            self.statusView.backgroundColor = UIColor.doneOption
        break;
        case .inProgress:
            self.statusView.backgroundColor = UIColor.inProgressOption
            break;
        case .rejected:
            self.statusView.backgroundColor = UIColor.rejectedOption
            break;
        default:
            //Set default color for other or nil status
            self.statusView.backgroundColor = UIColor.lightGray
        }
    }
}
