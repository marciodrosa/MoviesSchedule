//
//  HomeView.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 12/12/24.
//

import SwiftUI

/** The home view - the view that contains the tabs that shows the schedules and itinerary. */
struct HomeView: View {
    
    let scheduleSelectionViewFactory: ScheduleSelectionViewFactory
    let itineraryViewFactory: ItineraryViewFactory
    
    var body: some View {
        TabView{
            AnyView(scheduleView)
            .tabItem {
                tabItemView(label: "Schedule", icon: "square.and.pencil")
            }
            AnyView(itineraryView)
            .tabItem {
                tabItemView(label: "Itinerary", icon: "list.dash")
            }
        }
    }
    
    var scheduleView: any View {
        scheduleSelectionViewFactory.createView()
    }
    
    var itineraryView: any View {
        itineraryViewFactory.createView()
    }
    
    func tabItemView(label: String, icon: String) -> some View {
        VStack {
            Image(systemName: icon)
            Text(label)
        }
    }
}

#Preview {
    struct ScheduleSelectionViewFactoryMock: ScheduleSelectionViewFactory {
        func createView() -> any View {
            Text("Schedule selection content").font(Font.system(size: 24))
        }
    }
    
    struct ItineraryViewFactoryMock: ItineraryViewFactory {
        func createView() -> any View {
            Text("Itinerary content").font(Font.system(size: 24))
        }
    }
    
    return HomeView(scheduleSelectionViewFactory: ScheduleSelectionViewFactoryMock(), itineraryViewFactory: ItineraryViewFactoryMock())
}
