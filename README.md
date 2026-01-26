# api2spec-fixture-phoenix

A Phoenix (Elixir) API fixture for testing api2spec route extraction.

## Project Structure

```
api2spec-fixture-phoenix/
├── config/
│   └── config.exs
├── lib/
│   └── api2spec_fixture_phoenix/
│       ├── application.ex
│       ├── router.ex
│       └── controllers/
│           ├── health_controller.ex
│           ├── user_controller.ex
│           └── post_controller.ex
├── mix.exs
├── mix.lock
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## Docker Development

### Build and Run

```bash
# Build the Docker image
docker compose build

# Start the application
docker compose up app

# Or run in detached mode
docker compose up -d app
```

### Development Shell

```bash
# Start an interactive development shell
docker compose run --rm dev

# Inside the container, you can run:
mix deps.get
mix compile
iex -S mix
```

### Useful Commands

```bash
# View logs
docker compose logs -f app

# Stop all services
docker compose down

# Rebuild after changes to mix.exs
docker compose build --no-cache

# Remove volumes (clean slate)
docker compose down -v
```

## API Endpoints

The application exposes the following endpoints:

### Health

- `GET /health` - Health check
- `GET /health/ready` - Readiness check

### Users

- `GET /users` - List all users
- `GET /users/:id` - Get a specific user
- `POST /users` - Create a new user
- `PUT /users/:id` - Update a user
- `DELETE /users/:id` - Delete a user
- `GET /users/:user_id/posts` - Get posts for a specific user

### Posts

- `GET /posts` - List all posts
- `GET /posts/:id` - Get a specific post
- `POST /posts` - Create a new post
- `PUT /posts/:id` - Update a post
- `DELETE /posts/:id` - Delete a post

## Testing the API

Once the server is running on port 4000:

```bash
# Health check
curl http://localhost:4000/health

# List users
curl http://localhost:4000/users

# Get specific user
curl http://localhost:4000/users/1

# Create user
curl -X POST http://localhost:4000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Test User", "email": "test@example.com"}'

# List posts
curl http://localhost:4000/posts

# Get user's posts
curl http://localhost:4000/users/1/posts
```

## Local Development (without Docker)

If you have Elixir installed locally:

```bash
# Install dependencies
mix deps.get

# Compile
mix compile

# Start the server
mix phx.server

# Or start with interactive Elixir shell
iex -S mix phx.server
```

## Dependencies

- Phoenix ~> 1.7
- Jason ~> 1.4 (JSON library)
- Plug Cowboy ~> 2.6 (HTTP server)
