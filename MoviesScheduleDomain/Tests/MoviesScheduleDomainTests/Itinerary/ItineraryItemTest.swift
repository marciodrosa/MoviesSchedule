//
//  ItineraryItemTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Testing
@testable import MoviesScheduleDomain

struct ItineraryItemTest {
    
    @Test func shouldInitWithEndTime() {
        // when:
        let result = ItineraryItem(startAt: "14:50", endAt: "16:55", itineraryItemType: .interval())
        
        // then:
        #expect(result.startAt == "14:50")
        #expect(result.endAt == "16:55")
        #expect(result.itineraryItemType == .interval())
        #expect(result.duration == 125)
    }
    
    @Test func shouldInitWithDuration() {
        // when:
        let result = ItineraryItem(startAt: "14:50", duration: 125, itineraryItemType: .interval())
        
        // then:
        #expect(result.startAt == "14:50")
        #expect(result.endAt == "16:55")
        #expect(result.itineraryItemType == .interval())
        #expect(result.duration == 125)
    }
    
    @Test func shouldCreateNewItemWithNewItemType() {
        // given:
        let item = ItineraryItem(startAt: "14:50", duration: 125, itineraryItemType: .interval())
        
        // when:
        let newItem = item.withNewItineraryItemType(.interval(newTheater: Theater(id: 1, name: "AMC")))
        
        // then:
        #expect(newItem.startAt == "14:50")
        #expect(newItem.endAt == "16:55")
        #expect(newItem.itineraryItemType == .interval(newTheater: Theater(id: 1, name: "AMC")))
        #expect(newItem.duration == 125)
    }
}
