# AUTH API
| Route Name           | Method | Path                     | Controller#Action            |
|----------------------|--------|--------------------------|------------------------------|
| revoke_user_tokens  | POST   | /users/tokens/revoke/    | devise/api/tokens#revoke     |
| refresh_user_tokens | POST   | /users/tokens/refresh/   | devise/api/tokens#refresh    |
| sign_up_user_tokens | POST   | /users/tokens/sign_up    | devise/api/tokens#sign_up    |
| sign_in_user_tokens | POST   | /users/tokens/sign_in    | devise/api/tokens#sign_in    |
| info_user_tokens  | GET    | /users/tokens/info       | devise/api/tokens#info       |


# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
