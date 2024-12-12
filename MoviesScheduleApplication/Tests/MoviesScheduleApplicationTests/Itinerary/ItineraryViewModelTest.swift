//
//  ItineraryViewModelTest.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 12/12/24.
//
import Testing
import Foundation
import MoviesScheduleDomain
@testable import MoviesScheduleApplication

@MainActor
class ItineraryViewModelTest {
    
    actor ItineraryServiceMock: ItineraryService {
        
        private var itinerary: Itinerary = Itinerary(items: [])
        
        func setItinerary(_ itinerary: Itinerary) {
            self.itinerary = itinerary
        }
        
        func createItinerary() async -> Itinerary {
            return itinerary
        }
    }
    
    let itineraryService = ItineraryServiceMock()
    let viewModel: ItineraryViewModelImpl
    
    init() {
        viewModel = ItineraryViewModelImpl(itineraryService: itineraryService)
    }

    @Test func shouldLoad() async throws {
        // given:
        let itinerary = Itinerary(items: [
            .movie(movie: Movie(id: 1, title: "Star Wars", duration: 120), theater: Theater(id: 10, name: "AMC"), schedule: "18:00"),
            .interval(duration: 60),
            .movie(movie: Movie(id: 2, title: "Mad Max", duration: 120), theater: Theater(id: 10, name: "AMC"), schedule: "19:00")
        ])
        await itineraryService.setItinerary(itinerary)
        
        // when:
        await viewModel.load()

        // then:
        #expect(await viewModel.itinerary == itinerary)
        #expect(await !viewModel.loading)
    }

}
