//
//  ItineraryMovieView.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 16/10/25.
//

import SwiftUI
import MoviesScheduleDomain
import MoviesScheduleApplication

/** The view that shows a movie item within the user's itinerary. */
struct ItineraryMovieView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var dragOffsetX: Double = 0
    @State private var dragCancelled = false
    
    private let maxDragOffsetX: Double = 250
    private let maxDragOffsetY: Double = 250
    
    let movie: Movie
    let theater: Theater
    let schedule: String
    let conflicts: [ItineraryConflict]
    let onDelete: () -> Void
    
    init(movie: Movie, theater: Theater, schedule: String, conflicts: [ItineraryConflict], onDelete: @escaping () -> Void) {
        self.movie = movie
        self.theater = theater
        self.schedule = schedule
        self.conflicts = conflicts
        self.onDelete = onDelete
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            basicInfoView(movie: movie, theater: theater, schedule: schedule)
            ForEach(0..<conflicts.count, id: \.self) { i in
                conflictView(conflict: conflicts[i])
            }
        }
        .frame(alignment: .leading)
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .shadow(color: Color.black.opacity(0.25), radius: 6, x: 2, y: 3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .offset(x: dragOffsetX, y: 0)
        .opacity(1.0 - (abs(dragOffsetX) / maxDragOffsetX))
        .simultaneousGesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { drag in
                    if dragCancelled {
                        return
                    }
                    if abs(drag.translation.height) > maxDragOffsetY {
                        dragCancelled = true
                        dragOffsetX = 0
                        return
                    }
                    if abs(drag.translation.height) > abs(drag.translation.width) {
                        return
                    }
                    dragOffsetX = drag.translation.width
                }
                .onEnded { drag in
                    if !dragCancelled && abs(drag.translation.width) >= maxDragOffsetX {
                        onDelete()
                        return
                    }
                    dragCancelled = false
                    dragOffsetX = 0
                }
        )
    }
    
    private func basicInfoView(movie: Movie, theater: Theater, schedule: String) -> some View {
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
                Spacer()
                Button(action: {
                    onDelete()
                }, label: {
                    Image(systemName: "trash")
                })
            }
            .frame(maxWidth: CGFloat.infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title).font(Font.system(size: 24))
                Text("\(movie.duration) minutes", bundle: Bundle.module, comment: "Label below the movie title with the runtime duration").font(Font.system(size: 12))
            }
            .frame(maxWidth: CGFloat.infinity, alignment: .leading)
        }
    }
    
    private func conflictView(conflict: ItineraryConflict) -> some View {
        switch conflict {
        case .sameStartTime(movie: let movie, theater: let theater):
            conflictView(text: String(localized: "This movie starts at the same time as \(movie.title) at \(theater.name).", bundle: Bundle.module, comment: "Text explaining a conflict of selected movies in the itinerary"))
        case .startTimeBeforeOtherMovieEnded(movie: let movie, theater: let theater, conflictDuration: let conflictDuration):
            conflictView(text: String(localized: "This movie starts \(conflictDuration) minutes before movie \(movie.title) at \(theater.name) has ended.", bundle: Bundle.module, comment: "Text explaining a conflict of selected movies in the itinerary"))
        case .endTimeAfterOtherMovieStarted(movie: let movie, theater: let theater, conflictDuration: let conflictDuration):
            conflictView(text: String(localized: "This movie ends \(conflictDuration) minutes after movie \(movie.title) at \(theater.name) has started.", bundle: Bundle.module, comment: "Text explaining a conflict of selected movies in the itinerary"))
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
                Text("Warning: schedule conflict", bundle: Bundle.module, comment: "Title of the card in the itinerary with information regarding a schedule conflict")
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
}

#Preview {
    
    return ItineraryMovieView(
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
        ],
        onDelete: { print("Deleted") }
    )
}
