//
//  FavoriteViewController.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var favlabel: UILabel!
    
    var apodModelArray = [APODModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regiserNIB()
        self.title = Constants.favoriteTitle
        self.favlabel.alpha = 0
        
        self.apodModelArray = Utility.fetchAPODModel() ?? []
        
        self.apodModelArray =  self.apodModelArray.sorted(by: { Object1, Object2 in
            return Object1.date ?? "" > Object2.date ?? ""
        })
    }
    
    // MARK: - Private Methods
    private func regiserNIB(){
        favTableView.tableFooterView = UIView()
        favTableView.estimatedRowHeight = 50.0
        favTableView.rowHeight = UITableView.automaticDimension
        favTableView.register(UINib(nibName: Constants.addCell, bundle: nil), forCellReuseIdentifier: Constants.addCell)
    }
    
    deinit {
        Utility.customLog(Constants.freeFavoriteMemory)
    }
}

extension FavoriteViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if apodModelArray.count > 0
        {
            return apodModelArray.count
        }
        else
        {
            self.favlabel.alpha = 1
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
            
            if indexPath.row < self.apodModelArray.count
            {
                let model:APODModel = self.apodModelArray[indexPath.row]
                cell.selectionStyle = .none
                cell.parentVC = self
                cell.delegate = self
                cell.isFromFavorite = true
                
                cell.setAPODObject(model, index: indexPath.row)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension FavoriteViewController:APODCellProtocol {
    
    func deleteFav(index: Int) {
        
        let alertController = UIAlertController(title: Constants.deleteFavorite, message: Constants.favoriteOption, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: Constants.deleteTitle, style: .destructive, handler: { action in
            
            if index < self.apodModelArray.count
            {
                self.apodModelArray.remove(at: index)
                Utility.storeAPODModel(self.apodModelArray)
                DispatchQueue.main.async {
                    self.favTableView.reloadData()
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: Constants.cancelTitle, style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

