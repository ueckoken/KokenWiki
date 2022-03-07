# KokenWiki

KokenWiki is a Markdown wiki system built on top of Ruby on Rails

## Software stack

- Ruby 2.7
  - Rails 6.1
- Node.js 12
  - React + TypeScript
- MySQL 8.0

## Development

Docker and docker compose are recommended to setup your development environment

1. Start services
   - `docker compose up`
1. Intialize database
   - `docker compose exec rails rails db:create`
   - `docker compose exec rails rails db:migrate`
1. build JavaScript and CSS
   - `docker compose exec rails rails javascript:build`
1. visit local development server localhost:3000

## License

MIT
