//
//  ViewController.swift
//  Shoe Collector
//
//  Created by Zach Butcher on 7/24/17.
//  Copyright © 2017 Zach Butcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchController: UISearchBar!
    
    var shoes : [Shoes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        
        searchController.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getShoes(filterString: nil)
        tableview.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let shoe = shoes[indexPath.row]
        
        cell.textLabel?.text = shoe.name
        cell.imageView?.image = UIImage(data: shoe.image! as Data)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            getShoes(filterString: searchBar.text)
        }
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shoe = shoes[indexPath.row]
        performSegue(withIdentifier: "createGameSegue", sender: shoe)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.endEditing(true)
    }
    
    
    func getShoes(filterString: String?){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try shoes = context.fetch(Shoes.fetchRequest()) as! [Shoes]
        }catch{
            
        }
        
        if filterString != nil{
            shoes = shoes.filter { (mod) -> Bool in
                return (mod.name?.lowercased().contains(filterString!.lowercased()))!}
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ("createGameSegue"){
            let nextVC = segue.destination as! CreateGameViewController
            
            nextVC.shoe = sender as? Shoes
        }
        
    }
}

