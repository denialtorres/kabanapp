# Main Schema
![image](https://github.com/user-attachments/assets/1cee33b4-e82b-49ef-ae65-0ac4d9c77164)


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

# Roles
| Role         | Permissions                                                                 |
|-------------|----------------------------------------------------------------------------|
| **Super Admin** | Can **manage** everything (`:manage, :all`)                           |
| **Owner**      | Can **create, update, assign, move, and unassign** cards on boards they own (`Card`) |
|             | Can **create and update** boards (`Board`)                               |
|             | Can **delete** boards they own (`Board`)                                |
| **User**       | Can **move** cards they are assigned to (`Card`)                     |
| **Public**     | Can **read** boards and cards (`Board`, `Card`)                      |


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
## enable cache
```
  rails dev:cache
```

to verify
```ruby
  Rails.cache
  =>  <ActiveSupport::Cache::RedisCacheStore options={:namespace=>nil, :compress=>true, :compress_threshold=>1024, :expires_in=>nil, :race_condition_ttl=>nil} redis={:url=>"redis://redis:6379/1"}>
```

to access to the UI
```
  http://localhost:3000/fastentry
```



## Create multiple cards

```ruby
  board = Board.last
  developer = User.where(role: "user").last
  columns = board.column_ids

  50.times do
    card = Card.create!(
      column_id: columns.sample,
      name: "Task ##{rand(1000..9999)}",
      description: "This is a generated task",
      created_at: Time.current,
      updated_at: Time.current,
      deadline_at: Date.new(2025, 3, 15) + rand(1..30).days # Random future dat
    )

    UserCard.create!(user_id: developer.id, card_id: card.id)
  end
```
