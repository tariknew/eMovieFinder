# eMovieFinder
eMovieFinder is a comprehensive software solution developed as part of a seminar project for the Software Development II course. Using this application you can search, purchase and manage movies on the mobile and desktop application. The system is built with an ASP.NET Core Web API backend and a Flutter frontend.

## Features

- **Desktop Application**: Tailored for the administrators to manage things related to the movies.
- **Mobile Application**: Designed for the clients, they can purchase movies, search for them, as well as leave reviews.

## Technologies Used

- **Backend**: ASP.NET Core Web API with Entity Framework, both the API and the SQL database are containerized using Docker.
- **Frontend**: Flutter (for both desktop and mobile application).

## Getting Started

Follow the steps below to set up and run the project.

### Prerequisites

Ensure you have the following tools installed:
- **Docker**: For containerizing the backend.
- **Android Studio**: Recommended for editing and running the frontend (Flutter).
- **Flutter**: To run the desktop and mobile application.
- **SQL Server Management Studio 20**: To run the database.

### Clone the Repository

The following ZIP password for the fit-build-2025-01-11:

- **Password:** ```fit```

### Environment variables

The following environment variables are required:

- **Backend:** ```JWT_SECRET_KEY```, ```SEND_GRID_API_KEY```
  
You can define these variables by:

1. Editing a ```.env``` file in:

- **Backend:** ```eMovieFinder/.env```

### Running the Backend API

To start the API and other necessary services, navigate to the project's root folder (```eMovieFinder/```) and run the following command:

```bash
docker-compose up --build
```

### Recommender system information

When you open the mobile application, login with following account in order to see the list of recommended movies:

- **Username:** ```tarikadmin```
- **Password:** ```test```

### Warnings

The docker compose up command can take a few minutes. if it's running on a slower machine, so have patience.

### Credentials For PayPal Sandbox 

#### Sandbox account

- Email: ```testtest23@personal.example.com```
- Password: ```testtest```
  
### Credentials For Testing

#### Super administrator account

- Username: ```tariksuper```
- Password: ```test```
- Roles: ```Administrator and User```

#### Administrator account

- Username: ```tarikadmin```
- Password: ```test```
- Roles: ```Administrator```

#### Customer account

- Username: ```tarikbuyer```
- Password: ```test```
- Roles: ```Customer```

#### User account

- Username: ```tarikuser```
- Password: ```test```
- Roles: ```User```







