# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Frontend Build
- `yarn install` - Install Node.js dependencies
- `yarn build` - Build frontend assets with webpack
- `yarn check` - TypeScript type checking (no emit)
- `yarn prettier` - Format JavaScript/TypeScript/SCSS files

### Rails Commands
- `docker compose up` - Start development environment (recommended)
- `bundle install` - Install Ruby dependencies
- `bundle exec rails server` - Start Rails development server
- `bundle exec rails console` - Rails console
- `bundle exec rails test` - Run test suite

### Testing
- Test files are in `test/` directory using Rails default test framework
- System tests use Capybara with Selenium WebDriver
- Run specific tests: `bundle exec rails test test/models/page_test.rb`

### Linting
- Ruby: `bundle exec rubocop` (configured in Gemfile)
- JavaScript/TypeScript: Use `yarn prettier` for formatting

## Architecture Overview

### Technology Stack
- **Backend**: Ruby on Rails 6.1 with Ruby 3.3
- **Frontend**: React + TypeScript with Redux Toolkit for state management
- **Database**: MySQL 8.0 with fulltext search capabilities
- **Build**: Webpack with Babel for JS/TS compilation
- **Authentication**: Devise with custom controllers
- **Authorization**: CanCanCan for permission management

### Core Models and Relationships

#### Page Model (`app/models/page.rb`)
- Central wiki page entity with hierarchical structure
- Self-referential parent/child relationships for page organization
- Complex recursive SQL queries for path resolution and ancestor/descendant traversal
- Markdown content with CommonMarker parsing
- Link detection and backlink calculation
- Fulltext search capabilities on title and content

#### User and Permission System
- **User** (`app/models/user.rb`): Devise-based authentication with custom user_id field
- **Usergroup**: Group-based permissions for page access control
- **InvitationToken**: Admin-managed user registration system
- Pages have `readable_group` and `editable_group` for fine-grained access control

### Routing Architecture (`config/routes.rb`)
- Sophisticated constraint-based routing using `PageConstraint`, `FileConstraint`, and `CommentConstraint`
- Wiki-style URLs where paths map directly to page hierarchy
- Single controller endpoints handle different content types based on constraints
- Catch-all routes (`*pages/`) for hierarchical page paths

### Frontend Architecture

#### React Components (`app/javascript/components/`)
- **MdEditor**: Main editing interface with Redux state management
- **Markdown**: Rendered markdown display
- **DiffViewer**: Version comparison interface
- Redux store handles editing state, form data, and user permissions

#### State Management
- Redux Toolkit for editor state and form management
- TypeScript interfaces for type safety
- Integrated with Rails via CSRF tokens and form helpers

### Key Features

#### Hierarchical Pages
- Pages organized in tree structure with parent/child relationships
- Path-based URLs that mirror page hierarchy (e.g., `/parent/child/grandchild`)
- Automatic breadcrumb navigation
- Complex SQL queries for efficient tree traversal

#### Search System
- MySQL fulltext search on page title and content
- Two search modes: "natural_language" and "slower_stricter" (LIKE-based)
- Time-based filtering and multiple sort options

#### File Management
- ActiveStorage integration for file attachments
- Constraint-based routing differentiates between page and file requests
- Google Cloud Storage support for production

#### Version Control
- `UpdateHistory` model tracks page changes
- Diff viewer for comparing versions
- User attribution for all changes

### Development Environment
- Docker Compose setup recommended for consistency
- Webpack dev server for frontend asset compilation
- MySQL database with specific configuration for fulltext search
- Rails 6.1 with modern JavaScript integration via jsbundling-rails

### Database Schema Considerations
- Complex recursive CTEs for page hierarchy queries
- Fulltext indexes on page title and content
- Foreign key constraints with proper cascading
- Migration system handles schema evolution