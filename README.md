# Questions and Answers Application

This app based on main idea of stackoverflow: people can ask questions and create answers for them, created for lerning how some gems and technologies works.

## Features

- **Real-time Updates**: Actions mostly work without reload (AJAX). New records appear on the page without reload for all users.

## Authentication

- `devise`
- `omniauth`
  - `omniauth-github`
  - `omniauth-vkontakte`

## Authorization with Policies

- `cancancan`

## REST API

- `active_model_serializers`
- `doorkeeper`

## Attach Files to Questions/Answers

- `aws-sdk-s3`

## Background Jobs (e.g., Email)

- `active job`
- `sidekiq`
- `whenever`

## Redis

- **For Sidekiq and Caching**
  - Fragment caching (Russian doll caching)
  - `redis-rails`

## Sphinx Search (Full-text Search)

- `thinking-sphinx`

## Test Driven Development

Application is fully covered by tests: **496 specs**

- `rspec-rails`
- `factory_bot_rails`
- `shoulda-matchers`

## Feature (Acceptance) Testing with JS

- `capybara`

## Views

- `slim-rails`
- `bootstrap`

## Nested Forms

- `cocoon`

## Database

- `pg`

## Deployment

- `capistrano`

## Production Webserver

- `unicorn`
- `passenger`

## Services (Job Queues, Cache Servers, Search Engines, etc.)

- Postgres
- Redis
- Sidekiq
- WebSockets
- Sphinx
