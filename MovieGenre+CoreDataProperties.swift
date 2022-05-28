//
//  MovieGenre+CoreDataProperties.swift
//  MovieApp
//
//  Created by Five on 23.05.2022..
//
//

import Foundation
import CoreData


extension MovieGenre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGenre> {
        return NSFetchRequest<MovieGenre>(entityName: "MovieGenre")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var movies: NSSet?

}

// MARK: Generated accessors for movies
extension MovieGenre {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}

extension MovieGenre : Identifiable {

}
