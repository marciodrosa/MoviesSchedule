//
//  SwiftUIView.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 02/12/24.
//

import SwiftUI
import MoviesScheduleApplication
import MoviesScheduleDomain

public struct ScheduleSelectionView: View {
    
    let viewModel: ScheduleSelectionViewModel
    
    @State
    private var movieSchedules: [MovieSchedulesAggregate] = []
    
    @State
    private var loading: Bool = false
    
    public init(viewModel: ScheduleSelectionViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView()
                } else {
                    ScrollView(.vertical) {
                        VStack(
                            alignment: .leading,
                            spacing: 0
                        ) {
                            ForEach(movieSchedules) { movieSchedule in
                                movieView(movieSchedule)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Reload") {
                        Task {
                            loading = true
                            let vm = viewModel
                            await vm.load()
                            movieSchedules = await viewModel.movieSchedules
                            loading = false
                        }
                    }
                }
            }
        }
        
    }
    
    func movieView(_ movieSchedule: MovieSchedulesAggregate) -> some View {
        let theatersSchedules: [MovieSchedulesAggregate.Schedules] = movieSchedule.theatersSchedules
        return VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(movieSchedule.movie.title).font(Font.system(size: 24))
                Text(String(movieSchedule.movie.duration)).font(Font.system(size: 12))
            }
            VStack(alignment: .leading, spacing: 16) {
                ForEach(theatersSchedules) { theaterSchedule in
                    theaterSchedulesView(theaterSchedule)
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
    
    func theaterSchedulesView(_ theaterSchedule: MovieSchedulesAggregate.Schedules) -> some View {
        VStack(alignment: .leading) {
            Text(theaterSchedule.theater.name)
                .frame(maxWidth: CGFloat.infinity, alignment: .center)
            HStack {
                ForEach(theaterSchedule.schedules, id: \String.self) { schedule in
                    Toggle(isOn: Binding<Bool>.constant(false)) {
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
}

#Preview {
    actor ScheduleSelectionViewModelMock: ScheduleSelectionViewModel {
        var loading: Bool = false
        
        var movieSchedules: [MovieSchedulesAggregate] = [
            MovieSchedulesAggregate(
                movie: Movie(id: 1, title: "Star Wars", duration: 130),
                movieSchedules: [
                    MovieSchedules(movieId: 1, theaterId: 100, schedules: ["14:30", "18:00"]),
                    MovieSchedules(movieId: 1, theaterId: 200, schedules: ["16:30"]),
                ],
                theaters: [
                    Theater(id: 100, name: "AMC"),
                    Theater(id: 200, name: "Cinemark"),
                ]
            ),
            MovieSchedulesAggregate(
                movie: Movie(id: 2, title: "Mad Max", duration: 120),
                movieSchedules: [
                    MovieSchedules(movieId: 2, theaterId: 200, schedules: ["17:30", "21:00"]),
                ],
                theaters: [
                    Theater(id: 200, name: "Cinemark"),
                ]
            )
        ]
        
        func load() async {
            guard !loading else {
                return
            }
            loading = true
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            loading = false
        }
        
        func viewSummary() {
            print("Went to summary")
        }
    }
    
    return ScheduleSelectionView(viewModel: ScheduleSelectionViewModelMock())
}
