//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    private let cellID = "HomeTableViewCell"
    var viewModel: CleanerListViewModel!
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(actionRefreshVisiters), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.initViewModel()
        self.viewModel.onErrorHandling = { [weak self] error in
            // Display Error 
            self?.displayAlert(with: "An error occured", message: "Oops, something went wrong!", actions: [UIAlertAction(title: "Close", style: .cancel, handler: nil)])
        }
        //Initially load current date CarWasherVisits
        self.viewModel.filterCarWasherVisits(selectedDates: [Date().toString(format: .simpleDateFormat)], completionHandler: {
            self.workOrderTableView.reloadData()
        })
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
        }
    }

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        self.workOrderTableView.refreshControl = self.refreshControl
        self.calendarViewHeightConstraint.constant = 0
        self.tableViewTopConstraint.constant = 0
    }
    //MARK:- Initialize the view model
    func initViewModel(){
        self.viewModel = CleanerListViewModel()
        self.navBar.topItem?.title = self.viewModel.setTitle(arrayDatesSelected: ["Today"])
    }
    //MARK:- Refresh the table data
    @objc func actionRefreshVisiters() {
        self.workOrderTableView.reloadData()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    //MARK:- Show calendar when tapped on calendar icon
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        self.actionIsShowCalendar(isShow: true)
    }
    //MARK:- Show and hide calendar with animation
    func actionIsShowCalendar(isShow: Bool){
        self.workOrderTableView.isUserInteractionEnabled = !isShow
        if(isShow){
            self.calendarViewHeightConstraint.constant = 200
            self.tableViewTopConstraint.constant = 112
        }else{
            self.tableViewTopConstraint.constant = 0
            self.calendarViewHeightConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3){
             self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Hide calendar when tapped on view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.actionIsShowCalendar(isShow: false)
    }
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredArrayCarWasherVisits.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        //Configure cell data
        if indexPath.row == 0{
            cell.setData(carWasherVisitVM: CarWasherVisitViewModel(carWasherVisit: self.viewModel.filteredArrayCarWasherVisits[indexPath.row], previousCarWasherVisit: nil))
        }else{
            cell.setData(carWasherVisitVM: CarWasherVisitViewModel(carWasherVisit: self.viewModel.filteredArrayCarWasherVisits[indexPath.row], previousCarWasherVisit: self.viewModel.filteredArrayCarWasherVisits[indexPath.row-1]))
        }
        return cell
    }
}
   
//MARK:- Get selected calendar date 
extension HomeViewController: CalendarDelegate {
    //MARK:- Get all selected dates and filter CarWasherVisits
    func getSelectedDate(_ dates: [String]) {
        self.navBar.topItem?.title = self.viewModel.setTitle(arrayDatesSelected: dates)
        self.viewModel.filterCarWasherVisits(selectedDates: dates, completionHandler: {
            self.workOrderTableView.reloadData()
        })
    }
    
}

