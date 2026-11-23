# Chat UI

Day 20 of my daily project series — a chat app UI built with Flutter and Dart.

It looks like a normal messaging app: a list of chats with the last message,
time and unread count, and a conversation screen where you can send messages
and get a reply back.

## Features

- Chat list with profile initials, online dot and unread badges
- Search chats by name
- Swipe a chat to delete it, with Undo
- Conversation screen with message bubbles, time and read ticks
- Send a message and get a short reply back after a typing pause
- Opening a chat clears its unread count

## How to run

```bash
flutter pub get
flutter run
```

## What I practised

Building a chat layout with ListView and message bubbles, keeping the chat
data in a small model class, and writing unit and widget tests for it.
