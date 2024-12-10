//
//  ItineraryService.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

public protocol ItineraryService {
    func createItinerary(fromUserSchedule: UserSchedule) async -> Itinerary
}

struct ItineraryServiceImpl: ItineraryService {
    
    private let movieRepository: MovieRepository
    private let theaterRepository: TheaterRepository
    
    init(movieRepository: MovieRepository, theaterRepository: TheaterRepository) {
        self.movieRepository = movieRepository
        self.theaterRepository = theaterRepository
    }
    
    func createItinerary(fromUserSchedule userSchedule: UserSchedule) async -> Itinerary {
        var items = await createItineraryWithMovieItemsOnly(fromUserSchedule: userSchedule)
        
        return Itinerary(items: items)
    }
    
    func createItineraryWithMovieItemsOnly(fromUserSchedule userSchedule: UserSchedule) async -> [ItineraryItem] {
        let movieIds = userSchedule.items.map { $0.movieId }
        let theaterIds = userSchedule.items.map { $0.theaterId }
        let movies = (try? await movieRepository.get(byIds: movieIds)) ?? []
        let theaters = (try? await theaterRepository.get(byIds: theaterIds)) ?? []
        let scheduleItems = userSchedule.items.sorted { $0.schedule < $1.schedule }
        return scheduleItems.compactMap { scheduleItem in
            guard let movie = movies.first(where: { m in m.id == scheduleItem.movieId }) else {
                return nil
            }
            guard let theater = theaters.first(where: { t in t.id == scheduleItem.theaterId }) else {
                return nil
            }
            return ItineraryItem(startAt: scheduleItem.schedule, duration: movie.duration, itineraryItemType: .movie(movie: movie, theater: theater))
        }
    }
}
