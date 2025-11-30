# CHAT APP

make mini chat application

## 🚀 Tech Stack

### 📱 APPLICATION

- Flutter
- Provider
- socket.io client
- http
- Sqflite
- Shared preferences
- path

### 📡 SERVER

- Express js
- Socket.io
- Prisma ORM
- MongoDB
- Env
- Cors

## 📌 Features

- Register & Login
- Realtime chat with Socket.IO
- Send text messages
- Send image messages (upload)
- Delete message
- View chat list / recent conversations
- Profile update (photo + name)
- Online / offline indicator
- Local cache of messages with sqflite

## 📂 Folder Structure

```pgsql
    chat-app/
    ├── app/   # Express JS
    ├── server/  # Flutter dart
    └── admin / # React js
```

## 🛠️ How to install

```bash
    # clone repo
    git clone https://github.com/royarsitobatubara/chat-app.git
    cd chat-app

    # application
    cd app
    flutter pub get

    # server (in separate terminal)
    cd ../server
    npm install

    # dashboard (in separate terminal)
    cd ../dashboard
    npm install
```
