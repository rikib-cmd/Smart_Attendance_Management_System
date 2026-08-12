# Smart Attendance App

A smart attendance management system with a Node.js backend and Flutter frontend. This project supports teacher, student, department, subject, semester, and attendance management along with reporting features.

## Overview

The application is designed for educational institutions to manage attendance digitally, track student and teacher data, and generate attendance reports.

## Key Features

- User authentication for teachers, students and administrators
- Student, teacher, department, subject, and semester management
- Attendance capture and reporting
- Backend REST API built with Node.js and Express
- Mobile-friendly frontend built with Flutter
- MySQL database support

## Architecture

- `backend/` — Node.js Express API server
- `frontend/` — Flutter mobile application
- `backend/routes/` — API routes
- `backend/controllers/` — Request handlers and business logic
- `frontend/lib/` — Flutter app source code

## Tech Stack

- Backend: Node.js, Express, MySQL, bcryptjs, dotenv, cors
- Frontend: Flutter, Dart, http package

## Getting Started

### Backend setup

1. Navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file based on your environment and add the database configuration and server port.
4. Start the backend server:
   ```bash
   npm run dev
   ```

### Frontend setup

1. Navigate to the frontend folder:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## Recommended Git Workflow

- `git init`
- `git add .`
- `git commit -m "chore: initial import of smart attendance app"`
- Create a GitHub repository and add it as a remote
- `git push -u origin main`

## License

This project is licensed under the MIT License.
