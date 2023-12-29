# Time Manager API

This project aims to create a platform-independent API for Gotham City Hall to manage user information, working times, and clocking data.

## Installation

Ensure that you have Elixir and Docker installed on your system before proceeding.

Follow these links to install those softwares in case you don't have it :

https://elixir-lang.org/install.html

https://docs.docker.com/desktop/

### Local Installation

```
git clone git@github.com:EpitechMscProPromo2025/T-POO-700-PAR_8.git
```

```
mix deps.get
mix ecto.create
mix ecto.migrate
```

### Docker Installation

```
docker build -t timemanager-app:latest .
docker-compose down
docker-compose up
```

## Normal Usage

```
mix phx.server
```

## Testing

After migrating the database, ensure its accuracy and thoroughly test the various endpoints. You can use tools like Postman for comprehensive testing.
