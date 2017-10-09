//
//  ViewController.swift
//  Chimichanga
//
//  Created by Gordon on 2017-10-08.
//  Copyright © 2017 doxxx.net. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext! = nil
    
    lazy var fetchedResultsController: NSFetchedResultsController<Recipe> = {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // todo: predicate
        
        let controller: NSFetchedResultsController<Recipe> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unexpected error: \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Collection View

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView?.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipe = fetchedResultsController.object(at: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeThumbnailCell", for: indexPath) as! RecipeThumbnailCell
        
        cell.title = recipe.name
        cell.thumbnail = nil // todo: load thumbnail from core data
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowRecipe"?:
            guard let destination = segue.destination as? RecipeViewController else {
                fatalError("unexpected segue destination")
            }
            guard let cell = sender as? RecipeThumbnailCell else {
                fatalError("unexpected collection view cell")
            }
            guard let indexPath = collectionView?.indexPath(for: cell) else {
                fatalError("could not find indexPath for view cell")
            }
            destination.managedObjectContext = managedObjectContext
            destination.recipe = fetchedResultsController.object(at: indexPath)
            
        case "ShowAddRecipePopover"?:
            break
            
        case "ShowRecipeEditorWithBlank"?:
            guard let destination = segue.destination as? EditRecipeViewController else {
                fatalError("unexpected segue destination")
            }
            destination.managedObjectContext = managedObjectContext
            destination.recipe = nil
            
        default:
            break
        }
    }

    @IBAction func addBlankRecipe(unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowRecipeEditorWithBlank", sender: self)
        }
    }
    
    @IBAction func addRecipeFromWeb(unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowRecipeWebImporter", sender: self)
        }
    }

    @IBAction func save(unwindSegue: UIStoryboardSegue) {
        guard let context = managedObjectContext else { fatalError("no managed object context!") }

        do {
            try context.save()
        } catch {
            fatalError("could not save changes!")
        }
    }
    
    @IBAction func rollback(unwindSegue: UIStoryboardSegue) {
        guard let context = managedObjectContext else { fatalError("no managed object context!") }
        
        context.rollback()
    }
    
}

