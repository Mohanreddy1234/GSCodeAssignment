//
//  ViewController.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let apodViewModel:APODViewModel = APODViewModel()
    let datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regiserNIB()
        self.initNavBar()
        
        apodViewModel.apodViewModelProtocol = self
        apodViewModel.getAPODDetails(apodViewModel.getCurrentDate(), viewController: self)
    }
    
    
    private func initNavBar()
    {
        self.title = Constants.pictureOfDay
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchPictureByDate(_ :)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(viewFavorite))
    }
    
    private func regiserNIB()
    {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Constants.addCell, bundle: nil), forCellReuseIdentifier: Constants.addCell)
    }
    
    private func removePickerView()
    {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        
        self.view.endEditing(true)
    }
    
    // MARK: - IBAction Methods
    @IBAction func searchPictureByDate(_ sender: Any)
    {
        self.showDatePicker(sender as! UIBarButtonItem)
    }
    
    @IBAction func viewFavorite(_ sender: Any)
    {
        DispatchQueue.main.async
        {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            if let favVC = mainStoryBoard.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController
            {
                self.navigationController?.pushViewController(favVC, animated: true)
            }
        }
    }
    
    // MARK: - showDatePicker Methods
    func showDatePicker(_ searchButton:UIBarButtonItem) {
        
        datePicker.backgroundColor = UIColor.white
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.init(identifier: "UTC")
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        
        let doneButton = UIBarButtonItem(title: Constants.doneTitle, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.onDoneButtonClick))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: Constants.cancelTitle, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.cancelDatePicker))
        
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    // MARK: - dateChanged Methods
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = apodViewModel.getDateFormatter()
        
        var selectedDate:String? = nil
        
        if let date = sender?.date {
            selectedDate  = dateFormatter.string(from: date)
        }
        
        Utility.storeSelectedDate(selectedDate)
    }
    
    // MARK: - onDoneButtonClick Methods
    @objc func onDoneButtonClick() {
        
        self.removePickerView()
        
        if let existingDate = Utility.fetchSelectedDate()
        {
            apodViewModel.getAPODDetails(existingDate, viewController: self)
        }
    }
    
    // MARK: - cancelDatePicker Methods
    @objc func cancelDatePicker() {
        self.removePickerView()
    }
    
    deinit {
        Utility.customLog(Constants.freeViewControllerMemory)
    }
}

extension ViewController:APODViewModelProtocol {
    
    func showError() {
        DispatchQueue.main.async {
            
            if let model = Utility.fetchLastViewAPODModel()
            {
                self.apodViewModel.apodDetail = model
                self.tableView.reloadData()
            }
            
            if let error  = self.apodViewModel.errorMessage
            {
                let displayError = "Error Message: "+error
                Utility.showEddError(displayError, viewController:self)
            }
        }
    }
    
    func refreshAPOD() {
        DispatchQueue.main.async {
            
            if let model = self.apodViewModel.apodDetail
            {
                Utility.storeLastViewAPODModel(model)
            }
            
            self.tableView.reloadData()
        }
    }
}


extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apodViewModel.apodDetail != nil
        {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell: APODCell = tableView.dequeueReusableCell(withIdentifier: Constants.addCell, for: indexPath as IndexPath) as? APODCell {
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.parentVC = self
            
            cell.setAPODObject(apodViewModel.apodDetail)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ViewController:APODCellProtocol
{
    func addFav() {
        
        let alertController = UIAlertController(title: Constants.addFavorite, message: Constants.favoriteOption, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: Constants.addTitle, style: .destructive, handler: { action in
            
            if let model = self.apodViewModel.apodDetail, let date = model.date
            {
                var apodModelArray = [APODModel]()
                
                apodModelArray = Utility.fetchAPODModel() ?? []
                
                let apodObject:[APODModel]? = apodModelArray.filter({ (apodModel) -> Bool in
                    return apodModel.date?.caseInsensitiveCompare(date) == ComparisonResult.orderedSame
                })
                
                if apodObject?.count == 0
                {
                    apodModelArray.append(model)
                    Utility.storeAPODModel(apodModelArray)
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: Constants.cancelTitle, style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}


