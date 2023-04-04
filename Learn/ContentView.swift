//
//  ContentView.swift
//  Learn
//
//  Created by Mohammad Azam on 4/4/23.
//

import SwiftUI
import CoreData

struct MovieListView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var moviesResults: FetchedResults<Movie>
    @Environment(\.managedObjectContext) private var context: NSManagedObjectContext
    
    let movies: [Movie]
    
    var body: some View {
        VStack {
            List(movies) { movie in
                VStack {
                    Text(movie.title ?? "")
                    Text(movie.genre?.title ?? "")
                }
            }
            Button("Save Movie") {
                
                // get the genre
                let request = Genre.fetchRequest()
                request.predicate = NSPredicate(format: "title LIKE %@", "Action")
                let genre = try? context.fetch(request).first
                
                let movie = Movie(context: context)
                movie.title = "Superman"
                movie.genre = genre
                try? context.save()
            }
        }
    }
}

struct GenreListView: View {
    
    @Binding var selectedGenre: Genre?
    @Environment(\.managedObjectContext) private var context: NSManagedObjectContext
    
    @FetchRequest(sortDescriptors: [])
    private var allGenreResults: FetchedResults<Genre>
    
    var body: some View {
        VStack {
            List(allGenreResults, selection: $selectedGenre) { genre in
                NavigationLink(genre.title ?? "", value: genre)
            }
            Button("Add Genre") {
                let genre = Genre(context: context)
                genre.title = "Action"
                try? context.save()
            }
        }.navigationTitle("Genres")
    }
}


struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var context: NSManagedObjectContext
    @State private var genre: Genre?
    
    private var moviesByGenre: [Movie] {
        
        guard let selectedGenre = genre else { return [] }
        
        let request = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "genre = %@", selectedGenre)
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    var body: some View {
        NavigationSplitView {
            GenreListView(selectedGenre: $genre)
        } detail: {
            MovieListView(movies: moviesByGenre)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
}

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "FilmModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
    
}
