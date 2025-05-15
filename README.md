# KokenWiki

KokenWiki is a Markdown wiki system built on top of Ruby on Rails

## Software stack

- Ruby 3.3
  - Rails 6.1
- Node.js 23
  - React + TypeScript
- MySQL 8.0

## Development

Docker and docker compose are recommended to setup your development environment

1. build frontend
   - `yarn install && yarn build`
   - or delete volume mount `./:/app` in `compose.yml`, this mount is overwriting frontend artifacts
2. Start services
   - `docker compose up`
3. visit local development server localhost:3000

## License

MIT
