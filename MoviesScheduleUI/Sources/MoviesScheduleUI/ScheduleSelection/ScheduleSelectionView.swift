//
//  SwiftUIView.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 02/12/24.
//

import SwiftUI
import Combine
import MoviesScheduleApplication
import MoviesScheduleDomain

/** The view that shows the movies schedules and allows the player to pick them. */
public struct ScheduleSelectionView<ViewModel: ScheduleSelectionViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView()
                } else {
                    ScrollView(.vertical) {
                        VStack(
                            alignment: .leading,
                            spacing: 0
                        ) {
                            ForEach(viewModel.movies) { movie in
                                movieView(movie)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        Task {
                            await viewModel.load()
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                }
                ToolbarItem {
                    Button(action: {
                        Task {
                            await viewModel.clear()
                        }
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
        }.onAppear {
            Task {
                await viewModel.load()
            }
        }
    }
    
    func movieView(_ movie: Movie) -> some View {
        return VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(movie.title).font(Font.system(size: 24))
                Text("\(movie.duration) minutes", comment: "Label below the movie title with the runtime duration").font(Font.system(size: 12))
            }
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.theaters(byMovie: movie)) { theater in
                    theaterSchedulesView(theater: theater, movie: movie)
                }
            }
            .frame(maxWidth: CGFloat.infinity)
        }
        .frame(maxWidth: CGFloat.infinity)
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.25), radius: 6, x: 2, y: 3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    func theaterSchedulesView(theater: Theater, movie: Movie) -> some View {
        VStack(alignment: .leading) {
            Text(theater.name)
                .frame(maxWidth: CGFloat.infinity, alignment: .center)
            HStack {
                ForEach(theater.schedules(byMovie: movie), id: \String.self) { schedule in
                    Toggle(isOn: createScheduleItemBinding(movie: movie, theater: theater, schedule: schedule)) {
                        Text(schedule)
                    }.toggleStyle(.button)
                }
            }
            .frame(maxWidth: CGFloat.infinity, alignment: .leading)
        }
        .padding(.all, 8)
        .frame(maxWidth: CGFloat.infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .fill(Color.gray.opacity(0.5))
        }
    }
    
    private func createScheduleItemBinding(movie: Movie, theater: Theater, schedule: String) -> Binding<Bool> {
        return Binding {
            viewModel.isScheduleSelected(movie: movie, theater: theater, schedule: schedule)
        } set: { value in
            viewModel.setScheduleSelected(movie: movie, theater: theater, schedule: schedule, selected: value)
        }

    }
}

#Preview {
    final class ScheduleSelectionViewModelMock: ScheduleSelectionViewModel {
        
        @Published var loading: Bool = false
        
        var movies: [Movie] = [
            Movie(id: 1, title: "Star Wars", duration: 130),
            Movie(id: 2, title: "Mad Max", duration: 120),
        ]
        
        var userSchedule: UserSchedule = UserSchedule(items: [])
        
        func theaters(byMovie: Movie) -> [Theater] {[
            Theater(id: 1, name: "AMC", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 1, schedules: ["14:30", "18:00"]),
                MovieSchedules(movieId: 2, theaterId: 1, schedules: ["16:30"]),
            ]),
            Theater(id: 2, name: "Cinemark", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 1, schedules: ["17:30", "21:00"]),
                MovieSchedules(movieId: 2, theaterId: 1, schedules: ["20:30"]),
            ]),
        ]}
        
        func load() async {
            guard !loading else {
                return
            }
            loading = true
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            loading = false
        }
        
        func clear() async {
            userSchedule = UserSchedule(items: [])
        }
        
        func isScheduleSelected(movie: Movie, theater: Theater, schedule: String) -> Bool {
            userSchedule.isItemSelected(movie: movie, theater: theater, schedule: schedule)
        }
        
        func setScheduleSelected(movie: Movie, theater: Theater, schedule: String, selected: Bool) {
            _ = userSchedule.setItemSelected(movie: movie, theater: theater, schedule: schedule, selected: selected)
        }
    }
    
    return ScheduleSelectionView(viewModel: ScheduleSelectionViewModelMock())
}
