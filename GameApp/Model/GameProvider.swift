//
//  GameProvider.swift
//  GameApp
//
//  Created by Raihan on 18/11/23.
//
import Foundation
import CoreData

class GameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameApp")

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil

        return container
    }()

    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil

        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }

    func getAllGames(completion: @escaping(_ games: [Game]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [Game] = []
                for result in results {
                    if let id = result.value(forKeyPath: "id") as? Int,
                       let name = result.value(forKeyPath: "name") as? String,
                       let releaseDate = result.value(forKeyPath: "releaseDate") as? String,
                       let rating = result.value(forKeyPath: "rating") as? Double,
                       let image = result.value(forKeyPath: "image") as? String {
                        let game = Game(id: id, name: name, releaseDate: releaseDate, rating: rating, image: image)
                        games.append(game)
                    } else {
                        print("Error: Missing or invalid data for GameEntity")
                    }
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }


    func getGame(_ id: Int, completion: @escaping(_ game: Game?) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    let game = Game(
                        id: (result.value(forKeyPath: "id") as? Int)!,
                        name: (result.value(forKeyPath: "name") as? String)!,
                        releaseDate: (result.value(forKeyPath: "releaseDate") as? String)!,
                        rating: (result.value(forKeyPath: "rating") as? Double)!,
                        image: (result.value(forKeyPath: "image") as? String)!
                    )
                    completion(game)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion(nil)
            }
        }
    }

    func createGame(_ gameData: Game, completion: @escaping(_ success: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "GameEntity", in: taskContext) {
                let member = NSManagedObject(entity: entity, insertInto: taskContext)
                member.setValue(gameData.id, forKey: "id")
                member.setValue(gameData.name, forKey: "name")
                member.setValue(gameData.releaseDate, forKey: "releaseDate")
                member.setValue(gameData.rating, forKey: "rating")
                member.setValue(gameData.image, forKey: "image")
                do {
                    try taskContext.save()
                    completion(true)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                    completion(false)
                }
            }
        }
    }

    func deleteGame(_ id: Int, completion: @escaping(_ success: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)

            do {
                let objects = try taskContext.fetch(fetchRequest)
                for case let object as NSManagedObject in objects {
                    taskContext.delete(object)
                }

                try taskContext.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Error deleting game: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
