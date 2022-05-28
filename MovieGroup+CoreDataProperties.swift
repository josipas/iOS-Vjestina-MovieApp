//
//  MovieGroup+CoreDataProperties.swift
//  MovieApp
//
//  Created by Five on 23.05.2022..
//
//

import Foundation
import CoreData


extension MovieGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGroup> {
        return NSFetchRequest<MovieGroup>(entityName: "MovieGroup")
    }

    @NSManaged public var name: String?
    @NSManaged public var groupMovies: NSSet?

}

// MARK: Generated accessors for groupMovies
extension MovieGroup {

    @objc(addGroupMoviesObject:)
    @NSManaged public func addToGroupMovies(_ value: Movie)

    @objc(removeGroupMoviesObject:)
    @NSManaged public func removeFromGroupMovies(_ value: Movie)

    @objc(addGroupMovies:)
    @NSManaged public func addToGroupMovies(_ values: NSSet)

    @objc(removeGroupMovies:)
    @NSManaged public func removeFromGroupMovies(_ values: NSSet)

}

extension MovieGroup : Identifiable {

}
