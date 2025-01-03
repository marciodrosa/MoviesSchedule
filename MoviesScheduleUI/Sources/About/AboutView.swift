//
//  AboutView.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 02/01/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("Movie Schedule is an iOS demo app that allows the user to pick a few movies to watch in the theaters and then generate an itinerary containing the schedules, available intervals between the pictures and possible conflicts.\n\nThis is just a demo, containing fake data, made as an example of a Swift app that uses MVVM, DDD and modern Swift async programming, as well other technologies like SwiftUI and CoreData.", bundle: Bundle.module, comment: "The about text")
            HStack(spacing: 16) {
                Image("TMDBLogo", bundle: Bundle.module)
                    .resizable()
                    .scaledToFit()
                Text("This product uses the TMDB API but is not endorsed or certified by TMDB.", bundle: Bundle.module, comment: "The mandatory TMDB credits text")
            }
            Spacer()
        }
        .padding(.all, 32)
    }
}

#Preview {
    AboutView()
}
