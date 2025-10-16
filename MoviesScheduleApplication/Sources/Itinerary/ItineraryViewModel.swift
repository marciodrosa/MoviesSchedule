//
//  ItineraryViewModel.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 01/12/24.
//

import Foundation
import MoviesScheduleDomain

/** View model for the screen that presents the itinerary based on the user's selected schedules. */
@MainActor
public protocol ItineraryViewModel: ObservableObject {
    var loading: Bool { get }
    var itinerary: Itinerary { get }
    func load() async
}

public class ItineraryViewModelImpl: ItineraryViewModel {
    
    private let itineraryService: ItineraryService
    @Published public private(set) var loading: Bool = false
    @Published public private(set) var itinerary: Itinerary = Itinerary(items: [])
    
    public init(itineraryService: ItineraryService) {
        self.itineraryService = itineraryService
    }
    
    public func load() async {
        if loading {
            return
        }
        loading = true
        itinerary = await itineraryService.createItinerary()
        loading = false
    }
}
