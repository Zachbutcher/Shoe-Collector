//
//  ViewController.swift
//  Shoe Collector
//
//  Created by Zach Butcher on 7/24/17.
//  Copyright © 2017 Zach Butcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var shoes : [Shoes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getShoes()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shoe = shoes[indexPath.row]
        performSegue(withIdentifier: "createGameSegue", sender: shoe)
    }
    
    
    func getShoes(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try shoes = context.fetch(Shoes.fetchRequest()) as! [Shoes]
            print (shoes)
        }catch{
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ("createGameSegue"){
            let nextVC = segue.destination as! CreateGameViewController
            
            nextVC.shoe = sender as? Shoes
        }

    }
}

