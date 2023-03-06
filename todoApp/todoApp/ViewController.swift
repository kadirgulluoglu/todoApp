//
//  ViewController.swift
//  todoApp
//
//  Created by AyzaSoft on 6.03.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    var nameArray = [String]()
    var idArray = [UUID]()
    var selectedName = ""
    var selectedId : UUID?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(onClickAddButton))
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "veriGirildi"), object: nil)
    }
    
    @objc func getData (){
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(fetchRequest)
         
            for r in result as! [NSManagedObject] {
                if let name = r.value(forKey: "name") as? String{
                    nameArray.append(name)
                }
                if let id = r.value(forKey: "id") as? UUID{
                idArray.append(id)
                }
            }
            tableView.reloadData()
        }
        catch{
            print("hata var")
        }
        
    }
    

    @objc func onClickAddButton(){
        selectedName = ""
        performSegue(withIdentifier: "toDetailsVc", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVc"{
            let destinationVC = segue.destination as! FormViewController
            destinationVC.selectedId = selectedId
            destinationVC.selectedName = selectedName
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = nameArray[indexPath.row]
        selectedId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVc", sender: nil)
    }
}
