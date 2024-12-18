//
//  ItineraryView.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 12/12/24.
//

import SwiftUI
import MoviesScheduleDomain
import MoviesScheduleApplication

/** The view that shows the user's itinerary. */
struct ItineraryView<ViewModel: ItineraryViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else if viewModel.itinerary.items.count == 0 {
                emptyState
            } else {
                content
            }
        }
        .onAppear {
            Task {
                await viewModel.load()
            }
        }
    }
    
    var content: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(0..<viewModel.itinerary.items.count, id: \.self) { i in
                    let item = viewModel.itinerary.items[i]
                    switch item {
                    case .movie(movie: let movie, theater: let theater, schedule: let schedule):
                        movieView(movie: movie, theater: theater, schedule: schedule)
                    case .movieWithConflicts(movie: let movie, theater: let theater, schedule: let schedule, conflicts: let conflicts):
                        movieView(movie: movie, theater: theater, schedule: schedule, conflicts: conflicts)
                    case .interval(duration: let duration):
                        intervalView(duration: duration)
                    case .noInterval:
                        noIntervalView()
                    case .goToOtherTheater(availableTime: let availableTime, theater: let theater):
                        goToAnotherTheaterView(theater: theater, availableTime: availableTime)
                    case .goToOtherTheaterWithoutTime(theater: let theater):
                        goToAnotherTheaterViewWithoutInterval(theater: theater)
                    }
                }
            }
        }
    }
    
    var emptyState: some View {
        VStack(alignment: .center, spacing: 48) {
            Image(systemName: "number")
                .resizable()
                .frame(width: 48, height: 48)
            Text("No itinerary to show.")
            Text("Go to the Schedule tab and select the movies you want to see to create your itinerary.")
                .multilineTextAlignment(.center)
        }
        .padding(.all, 40)
    }
    
    func movieView(movie: Movie, theater: Theater, schedule: String, conflicts: [ItineraryConflict] = []) -> some View {
        VStack(alignment: .leading) {
            movieBasicInfoView(movie: movie, theater: theater, schedule: schedule)
            ForEach(0..<conflicts.count, id: \.self) { i in
                conflictView(conflict: conflicts[i])
            }
        }
        .frame(alignment: .leading)
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.25), radius: 6, x: 2, y: 3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    func movieBasicInfoView(movie: Movie, theater: Theater, schedule: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(schedule)
                    .bold()
                    .foregroundStyle(Color.white)
                    .padding(.all, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.blue)
                }
                Image(systemName: "arrow.right.square")
                Text(movie.endsAt(whenStartingAt: schedule))
                    .bold()
                    .foregroundStyle(Color.white)
                    .padding(.all, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(red: 0.5, green: 0.7, blue: 1))
                }
                Text(theater.name)
            }
            .frame(maxWidth: CGFloat.infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title).font(Font.system(size: 24))
                Text("\(movie.duration) minutes").font(Font.system(size: 12))
            }
            .frame(maxWidth: CGFloat.infinity, alignment: .leading)
        }
    }
    
    func conflictView(conflict: ItineraryConflict) -> some View {
        switch conflict {
        case .sameStartTime(movie: let movie, theater: let theater):
            conflictView(text: "This movie starts at the same time as \(movie.title) at \(theater.name).")
        case .startTimeBeforeOtherMovieEnded(movie: let movie, theater: let theater, conflictDuration: let conflictDuration):
            conflictView(text: "This movie starts \(conflictDuration) minutes before movie \(movie.title) at \(theater.name) has ended.")
        case .endTimeAfterOtherMovieStarted(movie: let movie, theater: let theater, conflictDuration: let conflictDuration):
            conflictView(text: "This movie ends \(conflictDuration) minutes after movie \(movie.title) at \(theater.name) has started.")
        }
    }
    
    func conflictView(text: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.red)
                .frame(width: 24, height: 24)
            VStack(alignment: .leading) {
                Text("Warning: schedule conflict")
                    .font(Font.system(size: 20))
                    .bold()
                    .foregroundStyle(Color.red)
                Text(text)
                    .foregroundStyle(Color.red)
            }
        }
        .padding(.all, 8)
        .background {
            RoundedRectangle(cornerRadius: 6)
                .stroke(lineWidth: 2)
                .fill(Color.red)
        }
    }
    
    func intervalView(duration: Int) -> some View {
        HStack {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 20, height: 20)
            Text("Interval (duration: \(duration) minutes)")
        }
        .frame(alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 1, green: 0.9, blue: 0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    func noIntervalView() -> some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(width: 20, height: 20)
            Text("Warning: no interval between movies").bold()
        }
        .frame(alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 1, green: 0.7, blue: 0.0))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    func goToAnotherTheaterView(theater: Theater, availableTime: Int) -> some View {
        HStack {
            Image(systemName: "figure.walk.circle")
                .resizable()
                .frame(width: 20, height: 20)
            VStack(alignment: .leading) {
                Text("Go to \(theater.name) for the next movie")
                Text("(Interval duration: \(availableTime) minutes)")
            }
        }
        .frame(alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.9, green: 1, blue: 0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    func goToAnotherTheaterViewWithoutInterval(theater: Theater) -> some View {
        HStack {
            Image(systemName: "figure.walk.circle")
                .resizable()
                .frame(width: 20, height: 20)
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(width: 20, height: 20)
            VStack(alignment: .leading) {
                Text("Go to \(theater.name) for the next movie")
                Text("Warning: no interval available").bold()
            }
        }
        .frame(alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 1, green: 0.7, blue: 0.0))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    final class ItineraryViewModelMock: ItineraryViewModel {
        var loading: Bool = false
        
        var itinerary: Itinerary = Itinerary(items: [
            .movie(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "13:00"
            ),
            .interval(duration: 30),
            .movieWithConflicts(
                movie: Movie(id: 2, title: "The Godfather", duration: 180),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "15:30",
                conflicts: [
                    .endTimeAfterOtherMovieStarted(
                        movie: Movie(id: 3, title: "Mad Max", duration: 120),
                        theater: Theater(id: 10, name: "AMC"),
                        conflictDuration: 30
                    ),
                    .endTimeAfterOtherMovieStarted(
                        movie: Movie(id: 4, title: "Sideways", duration: 120),
                        theater: Theater(id: 10, name: "AMC"),
                        conflictDuration: 30
                    )
                ]
            ),
            .movieWithConflicts(
                movie: Movie(id: 3, title: "Mad Max", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "16:00",
                conflicts: [
                    .startTimeBeforeOtherMovieEnded(
                        movie: Movie(id: 2, title: "The Godfather", duration: 180),
                        theater: Theater(id: 10, name: "AMC"),
                        conflictDuration: 120
                    ),
                    .sameStartTime(
                        movie: Movie(id: 4, title: "Sideways", duration: 120),
                        theater: Theater(id: 10, name: "AMC")
                    )
                ]
            ),
            .movieWithConflicts(
                movie: Movie(id: 4, title: "Sideways", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "16:00",
                conflicts: [
                    .startTimeBeforeOtherMovieEnded(
                        movie: Movie(id: 2, title: "The Godfather", duration: 180),
                        theater: Theater(id: 10, name: "AMC"),
                        conflictDuration: 120
                    ),
                    .sameStartTime(
                        movie: Movie(id: 3, title: "Mad Max", duration: 120),
                        theater: Theater(id: 10, name: "AMC")
                    )
                ]
            ),
            .noInterval,
            .movie(
                movie: Movie(id: 5, title: "Star Trek", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "19:30"
            ),
            .goToOtherTheater(
                availableTime: 10,
                theater: Theater(id: 20, name: "Cinemark")
            ),
            .movie(
                movie: Movie(id: 6, title: "Short Movie", duration: 10),
                theater: Theater(id: 20, name: "Cinemark"),
                schedule: "21:40"
            ),
            .goToOtherTheaterWithoutTime(
                theater: Theater(id: 10, name: "AMC")
            ),
            .movie(
                movie: Movie(id: 7, title: "Short Movie 2", duration: 10),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "21:50"
            ),
        ])
        
        func load() async {
            
        }
    }
    
    return ItineraryView(viewModel: ItineraryViewModelMock())
}
