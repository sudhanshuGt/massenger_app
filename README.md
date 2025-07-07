# 📩 Messenger App (Flutter + Spring Boot)

A modern messaging app built using **Flutter (MVVM architecture)** and **Spring Boot REST APIs**, featuring login, signup, search, and real-time-like chat experience via polling.

---

## 📱 Features

- 🔐 **Authentication**
    - Signup and Login using username & password.
    - Stores token and user info in `SharedPreferences`.

- 🏠 **Home Screen with Bottom Navigation**
    - `Chat` tab: Shows latest conversations.
    - `Search` tab: Search for users with live query and connect.
    - `Profile` tab: View current user info & logout.

- 💬 **Chat Screen**
    - View message history with selected user.
    - Send new messages.
    - Messages auto-refresh using polling every 3 seconds.
    - Displays sent/received messages with UI separation.

- 🌐 **Backend (Spring Boot)**
    - JWT-based authentication.
    - CORS-enabled for web support.
    - H2 in-memory database.

---

## 🧱 Tech Stack

### 🔹 Flutter (Frontend)
- MVVM architecture
- `provider` for state management
- `dio` for networking
- `shared_preferences` for local storage
- Clean UI with Material 3

### 🔹 Spring Boot (Backend)
- JWT Authentication
- REST APIs for user, search, message, and chat
- H2 Database for development
- CORS Configured for cross-origin requests

---

## 📂 Folder Structure

lib/
├── model/ # All data models (User, Message, Chat, etc.)
├── presentation/ # Screens and UI tabs
├── repository/ # Service classes (AuthService, ChatService)
├── viewmodel/ # ViewModels (AuthViewModel, ChatViewModel)
└── main.dart # App entry point


---

## 🛡️ Authentication Flow

1. On successful login, token & user info saved to `SharedPreferences`.
2. Token sent in all authorized requests via `Authorization: Bearer {token}`.
3. Logout clears saved data and navigates to login.

---

## 🧠 Optimizations

- 💬 Chat messages use polling every 3s (can be upgraded to WebSockets).
- ✨ UI updates only when new messages detected (via hashing).
- 🔁 Back stack cleared after login/signup for cleaner navigation.

---

## 🤝 Contributing

1. Fork this repo
2. Create your feature branch (`git checkout -b feature/awesome-feature`)
3. Commit your changes (`git commit -am 'Add awesome feature'`)
4. Push to the branch (`git push origin feature/awesome-feature`)
5. Create a new Pull Request


---

## 🔗 API Endpoints (Spring Boot)

## https://github.com/sudhanshuGt/chat_backend

| Endpoint                         | Method | Description                   |
|----------------------------------|--------|-------------------------------|
| `/api/auth/signup`              | POST   | Register new user             |
| `/api/auth/login`               | POST   | Login and get JWT token       |
| `/api/auth/search?username=`    | GET    | Search users by username      |
| `/api/messages/conversations`   | GET    | Get latest user conversations |
| `/api/messages/chats/{username}`| GET    | Get full conversation history |
| `/api/messages/send`            | POST   | Send a message                |

---

