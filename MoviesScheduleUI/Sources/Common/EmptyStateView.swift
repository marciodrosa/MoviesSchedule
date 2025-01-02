//
//  EmptyStateView.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 02/01/25.
//

import SwiftUI

/** Generic and customizable empty state view. */
struct EmptyStateView: View {
    
    let systemImageName: String
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 48) {
            Image(systemName: systemImageName)
                .resizable()
                .frame(width: 48, height: 48)
            Text(title)
            Text(text)
                .multilineTextAlignment(.center)
        }
        .padding(.all, 40)
    }
}

#Preview {
    EmptyStateView(systemImageName: "number", title: "Some title", text: "This is the text of the empty state view with multiple lines.")
}
