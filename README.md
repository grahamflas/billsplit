# 💰 Bill÷Split

[![React](https://img.shields.io/badge/React-19.1.1-blue.svg)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.9.2-blue.svg)](https://www.typescriptlang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.2-red.svg)](https://rubyonrails.org/)
[![Ruby](https://img.shields.io/badge/Ruby-3.3.1-red.svg)](https://www.ruby-lang.org/)

A modern full-stack expense splitting application built with Rails 8 and React. Bill÷Split allows groups of users to track shared expenses, calculate balances, and settle debts - perfect for roommates, travel groups, or shared activities.

## 🚀 Live Demo

**[View Live Application](https://billsplit-lylg.onrender.com/)**

## ✨ Key Features

- 📱 **Responsive Design**: Mobile-first interface built with Tailwind CSS and React
- 🏢 **Group Management**: Create groups and invite members via the app or email
- 💳 **Expense Tracking**: Add, edit, and delete shared expenses with automatic balance calculations
- 📊 **Smart Settlements**: Track who owes whom and settle debts between group members
- 🔔 **Real-time Notifications**: Notify group members of new expenses and activity
- 🔑 **User Authentication**: Secure authentication with Devise

## 🏗️ Architecture & Technical Highlights

### Backend (Rails 8)
- **Modern Rails Stack**: Built with Rails 8, leveraging the latest features and conventions
- **API-First Design**: RESTful JSON API with dedicated API controllers and serializers
- **Domain-Driven Architecture**: Clean separation of concerns with events ([`app/events/`](https://github.com/grahamflas/billsplit/tree/main/app/events)) and query objects ([`app/queries/`](https://github.com/grahamflas/billsplit/tree/main/app/queries)) for complex business logic
- **Event-Driven Notifications**: Custom notification system with in-app and email notifications
- **Comprehensive Testing**: Comprehensive test coverage leveraging RSpec ad Capybara for unit, request, and system tests

### Frontend (React + TypeScript)
- **Hybrid Architecture**: Rails views with embedded React components
- **Modern Build Pipeline**: Vite for fast development and optimized production builds
- **Type Safety**: Full TypeScript implementation with strict type checking
- **Repository Pattern**: API abstraction for clean separation of client and data-access layer
- **Component Library**: Reusable React components with third party component libraries (Headless UI and Radix UI)


## 🛠️ Tech Stack

**Backend:**
- Ruby 3.3.1
- Rails 8.0.2
- PostgreSQL
- Devise (Authentication)
- Active Model Serializers

**Frontend:**
- React 19
- TypeScript 5.9
- Vite
- Tailwind CSS

**Testing & Quality:**
- RSpec
- Capybara with Cuprite (headless Chrome)
- Factory Bot
- Shoulda Matchers

## 📊 Business Logic Highlights

### Balance Calculation Engine
The [`Balances`](https://github.com/grahamflas/billsplit/blob/main/app/queries/balances.rb) query object implements sophisticated balance calculation logic:
- Calculates each member's share of total group expenses
- Determines who owes whom and how much
- Handles complex multi-member debt scenarios

### Notification System
Custom notification framework that:
- Tracks expense additions, updates, settlements, group membership updates
- Sends email notifications via SendGrid
- Provides in-app notification management

### Invitation Workflow
Invitation system featuring:
- Email-based invitations with accept/decline functionality
- User creation for new members
- Automatic group membership management

## 🧪 Testing Strategy

- **Unit Tests**: Models, services, and query objects with edge case coverage
- **Integration Tests**: API endpoints with authentication and authorization
- **System Tests**: End-to-end user workflows with Capybara and headless Chrome
- **Factory Bot**: Realistic test data generation with proper associations

## 🚦🛠️ Getting Started - Local Development
To get started with local development after cloning the repository:

1. Install dependencies:
```bash
bundle install
yarn install
```

2. Set up the database:
```bash
bin/rails db:setup
```

3. Start the Rails server:

Open a terminal and run:
```bash
bin/rails s
```
This will start the backend API and serve Rails views.

4. Start the frontend build/watch process:

In a **separate** terminal, run:

```bash
yarn watch
```

This will start Vite and TypeScript in watch mode, enabling hot reloading for React components and assets.

5. Access the app: Visit http://localhost:3000 in your browser.

Tip:

- Make sure PostgreSQL is running locally.
- You can run tests with bundle exec rspec.
- Environment variables can be set in a .env file for local configuration.

You’re now ready to develop and test Bill÷Split locally!



