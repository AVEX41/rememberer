//
//  CreationView.swift
//  rememberer
//
//  Created by Aleksander Hoff on 02/05/2023.
//

import SwiftUI


struct CreationView: View {
    var body: some View {
        @State var TextName = ""

        List {
            TextField("Enter name", text: $TextName)
        }
    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
