//
//  DetailView.swift
//  ClassView
//
//  Created by admin on 2022/10/26.
//

import SwiftUI

struct MessageView: View {
    var note: String
    var body: some View {
        Text(note)
    }
}

struct ImageView: View {
    var title: String
    var image: NSImage
    var body: some View {
        Text(title)
        Image(nsImage: image)
        Spacer()
    }
}

struct Message: Identifiable {
    var id: Int
    var message: String
}

class MessageModel: ObservableObject {
    @Published var messages: [Message]
    init(messages: [Message]) {
        self.messages = messages
    }
}

struct MessageDetailView: View {
    @StateObject var model: MessageModel
    var body: some View {
        ScrollViewReader { sp in
            List {
                ForEach(self.model.messages, id: \.id) { message in
                    MessageView(note: message.message)
                }
            }
            .onReceive(self.model.$messages) { _ in
                DispatchQueue.main.async {
                    guard !self.model.messages.isEmpty else { return }
                    withAnimation(Animation.easeInOut) {
                        sp.scrollTo(self.model.messages.last!.id)
                    }
                }
            }
        }
        //        ScrollView {
        //            ScrollViewReader { sp in
        //                LazyVStack {
        //                    ForEach(self.model.messages, id: \.id) { message in
        //                        MessageView(note: message.message)
        //                    }
        //                }
        //                .onReceive(self.model.$messages) { _ in
        //                    DispatchQueue.main.async {
        //                        guard !self.model.messages.isEmpty else { return }
        //                        withAnimation(Animation.easeInOut) {
        //                            sp.scrollTo(self.model.messages.last!.id)
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
}

struct ImageDetailView: View {
    @State var messages: [String]
    var body: some View {
        VStack{
            ScrollView(.vertical) {
                ScrollViewReader { scrollView in
                    LazyVStack {
                        ForEach(messages, id: \.self) { note in
                            MessageView(note: note)
                        }
                    }
                    .onAppear {
                        if messages.endIndex > 1 {
                            scrollView.scrollTo(messages[messages.endIndex - 1])
                        }
                    }
                }
            }
        }
    }
}
