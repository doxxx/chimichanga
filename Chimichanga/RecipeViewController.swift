//
//  RecipeViewController.swift
//  Chimichanga
//
//  Created by Gordon on 2017-10-08.
//  Copyright © 2017 doxxx.net. All rights reserved.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext! = nil
    weak var recipe: Recipe! = nil
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateFields()
    }

    func updateFields() {
        navigationItem.title = recipe.name
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowRecipeEditorForRecipe"?:
            guard let destination = segue.destination as? EditRecipeViewController else {
                fatalError("unexpected segue destination")
            }
            destination.managedObjectContext = managedObjectContext
            destination.recipe = recipe
        default:
            break
        }
    }

    @IBAction func save(unwindSegue: UIStoryboardSegue) {
        guard let context = managedObjectContext else { fatalError("no managed object context!") }
        
        do {
            try context.save()
        } catch {
            fatalError("could not save changes!")
        }
        
        updateFields()
    }
    
    @IBAction func rollback(unwindSegue: UIStoryboardSegue) {
        guard let context = managedObjectContext else { fatalError("no managed object context!") }
        
        context.rollback()
    }
    
}
