# Board Game Borrowing Platform

A modern web application that allows users to borrow and share board games with friends. Built with Ruby on Rails and modern web technologies.

## Features

### For Users
- Create and manage your profile
- Add board games to your collection using barcode scanning
- Borrow games from friends
- Search and discover new games
- Manage your game library
- Social features (friends system, borrowing history)

### For Game Owners
- Easy game registration with barcode scanning
- Track your game collection
- Manage lending and returns
- Set availability status
- View borrowing history

## Tech Stack

- Ruby on Rails
- PostgreSQL
- SCSS for styling
- Bootstrap for responsive design
- Turbo for dynamic interactions

## Getting Started

### Prerequisites
- Ruby 3.0.0 or higher
- PostgreSQL
- Node.js and Yarn

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/board_game_borrowing.git
cd board_game_borrowing
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Setup the database
```bash
rails db:create db:migrate
```

4. Start the server
```bash
rails s
```

Visit `http://localhost:3000` to see the application.

## Usage

1. **Sign Up/Login**
   - Create an account or login with your credentials
   - Complete your profile

2. **Add Games**
   - Use the barcode scanner to add games to your collection
   - Fill in game details (number of players, duration, etc.)

3. **Borrow Games**
   - Browse available games
   - Request to borrow from friends
   - Track your borrowed games

4. **Manage Your Collection**
   - View your game library
   - Set availability status
   - Track lending history

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
