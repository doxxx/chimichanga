//
//  NewRecipeViewController.swift
//  Chimichanga
//
//  Created by Gordon on 2017-10-08.
//  Copyright © 2017 doxxx.net. All rights reserved.
//

import UIKit
import CoreData

class EditRecipeViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext! = nil
    weak var recipe: Recipe? = nil
    
    @IBOutlet weak var name: UITextField!
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateFields()
    }
    
    private func updateFields() {
        if let recipe = recipe {
            name.text = recipe.name
        }
        else {
            name.text = ""
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipe = self.recipe ?? NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: managedObjectContext) as! Recipe
        switch segue.identifier {
        case "Save"?:
            recipe.name = name.text
        default:
            break
        }
    }

}
