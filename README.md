# Main Schema
![image](https://github.com/user-attachments/assets/13a891cd-d9f6-470b-bb57-7b5076a49946)


# AUTH API
| Route Name           | Method | Path                     | Controller#Action            |
|----------------------|--------|--------------------------|------------------------------|
| revoke_user_tokens  | POST   | /users/tokens/revoke/    | devise/api/tokens#revoke     |
| refresh_user_tokens | POST   | /users/tokens/refresh/   | devise/api/tokens#refresh    |
| sign_up_user_tokens | POST   | /users/tokens/sign_up    | devise/api/tokens#sign_up    |
| sign_in_user_tokens | POST   | /users/tokens/sign_in    | devise/api/tokens#sign_in    |
| info_user_tokens  | GET    | /users/tokens/info       | devise/api/tokens#info       |

# Documentation
```
http://localhost:3000/api-docs/
```

## Docker

To mount the project
inside the main foler:

```
docker-compose up --build
```

For run the migrations

```
docker-compose exec app rails db:migrate
```

Run the seed files

```
docker-compose exec app rails db:seed
```

To connect to the rails console

```
docker-compose exec app rails c
```

Run the server

```
docker-compose exec app rails server -b 0.0.0.0
```

Run Sidekiq

```
docker-compose exec app bundle exec sidekiq
```

Reset the db

```
docker-compose exec app bundle exec rails db:drop db:setup
```

Shell
```
docker-compose exec app /bin/bash
```

Tests
```
docker-compose run -e "RAILS_ENV=test" app bundle exec rspec
```

Rubocop
```
./bin/rubocop -a
```

Swagger
inside the container
```
rails rswag:specs:swaggerize RAILS_ENV=test
```


peding stuff

delete card endpoint
github stuff

pagination, filtering and sorting options


