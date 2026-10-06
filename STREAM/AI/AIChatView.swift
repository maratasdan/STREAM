//
//  AIChatView.swift
//  STREAM
//
//  Created by dan on 9/22/26.
//

import SwiftUI

struct AIChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct AIChatView: View {

    @State private var messageText = ""

    @State private var messages: [AIChatMessage] = [
        AIChatMessage(
            text: "Hi! I'm Stellar Seeds AI. How can I help you with your operations today?",
            isUser: false
        )
    ]

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Header

            HStack(spacing: 12) {

                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {

                    Text("Stellar Seeds AI")
                        .font(.headline)

                    Text("Operations Assistant")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Circle()
                    .fill(.green)
                    .frame(width: 9, height: 9)

                Text("Online")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))

            Divider()

            // MARK: - Chat Messages

            ScrollViewReader { proxy in

                ScrollView {

                    LazyVStack(spacing: 16) {

                        ForEach(messages) { message in

                            HStack {

                                if message.isUser {
                                    Spacer(minLength: 50)
                                }

                                Text(message.text)
                                    .padding(12)
                                    .foregroundStyle(
                                        message.isUser ? .white : .primary
                                    )
                                    .background(
                                        message.isUser
                                        ? Color.blue
                                        : Color(.secondarySystemBackground)
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )

                                if !message.isUser {
                                    Spacer(minLength: 50)
                                }
                            }
                            .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) {
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(
                                lastMessage.id,
                                anchor: .bottom
                            )
                        }
                    }
                }
            }

            Divider()

            // MARK: - Message Input

            HStack(spacing: 12) {

                TextField(
                    "Ask about your operations...",
                    text: $messageText,
                    axis: .vertical
                )
                .lineLimit(1...4)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Button {
                    sendMessage()
                } label: {

                    Image(systemName: "arrow.up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            messageText.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty
                            ? Color.gray
                            : Color.blue
                        )
                        .clipShape(Circle())
                }
                .disabled(
                    messageText.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle("AI Assistant")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Send Message

    private func sendMessage() {

        let question = messageText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !question.isEmpty else { return }

        messages.append(
            AIChatMessage(
                text: question,
                isUser: true
            )
        )

        messageText = ""

        // Temporary response for UI testing.
        // We will replace this with the actual AI API request.

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            messages.append(
                AIChatMessage(
                    text: "Your question has been received. AI integration is coming next!",
                    isUser: false
                )
            )
        }
    }
}

#Preview {
    NavigationStack {
        AIChatView()
    }
}
