//
//  ShortcutsView.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/1/22.
//

import SwiftUI

struct ShortcutsView: View {
    @State private var selection : Int? = nil
    
    var body: some View {
        List(0..<5, selection: $selection) {
            Text(String($0))
        }.padding(.init(top: -5, leading: -5, bottom: -5, trailing: -5)).edgesIgnoringSafeArea(.top).listRowInsets(.none)
            .frame(minWidth: 100, maxWidth: 500, minHeight: 100)
            .fixedSize()
    }
}

struct ShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutsView()
    }
}
