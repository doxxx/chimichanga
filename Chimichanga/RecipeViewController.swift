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
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directionsTable: UITableView!
    @IBOutlet weak var ingredientsTable: UITableView!
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateFields()
    }

    func updateFields() {
        if recipe.thumbnailIndex < 0 {
            thumbnailImage.image = UIImage(named: "RecipePlaceholderIcon")
        }
        else {
            // todo: get real thumbnail image
        }
        titleLabel.text = recipe.name
        directionsTable.reloadData()
        ingredientsTable.reloadData()
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
    
    // MARK: - Actions
    
    @IBAction func showDeleteConfirmation(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete Recipe", style: .destructive, handler: { _ in
            self.deleteRecipe()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteRecipe() {
        guard let context = managedObjectContext else { fatalError("no managed object context!") }
        context.delete(recipe)
        performSegue(withIdentifier: "UnwindAfterDeletion", sender: self)
    }
    
}
