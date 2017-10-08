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
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    lazy var fetchedResultsController: NSFetchedResultsController<Recipe> = {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // todo: predicate
        
        let controller: NSFetchedResultsController<Recipe> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unexpected error: \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

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
        
        cell.title = recipe.name!
        cell.thumbnail = nil // todo: load thumbnail from core data
        
        return cell
    }

    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        guard let context = managedObjectContext else { fatalError("no managed object context!") }
        
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context) as! Recipe
        recipe.name = "Some Tasty Recipe"
        
        do {
            try context.save()
        } catch {
            fatalError("could not save new recipe!")
        }
    }
}

