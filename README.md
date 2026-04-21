# Library App

[![CI](https://github.com/RoverWire/library-app/actions/workflows/ci.yml/badge.svg)](https://github.com/RoverWire/library-app/actions/workflows/ci.yml) [![Rails 8.1.3](https://badgen.net/badge/Rails/8.1.3/red)](https://github.com/RoverWire/library-app/blob/main/Gemfile) [![Ruby 4.0.2](https://badgen.net/badge/Ruby/4.0.2/red)](https://github.com/RoverWire/library-app/blob/main/.ruby-version)

A Ruby on Rails API for managing a library system with role-based access control.
Supports book management, borrowing workflows, and user roles (Admin, Librarian, Member).

## Requirements

- Ruby 4.0.2
- PostgreSQL

## Setup

Make sure you have the required ruby version listed in `.ruby-verion` file. If you are using any ruby version manager you can do it with any of the following steps:

Using RVM or RBENV

```bash
# Install the ruby version
$ [rvm | rbenv] install 4.0.2

# Select the ruby version installed
$ [rvm | rbenv] use 4.0.2
```

Using ASDF

```bash
# Install the ruby version
$ asdf ruby install 4.0.2

# Select the ruby version installed for the current folder
$ asdf asdf local ruby 4.0.2

# Alternative if you already have the repository
$ asdf local ruby $(cat .tool-versions | grep ruby | awk '{print $2}')
```

### Clone the repository

```bash
# Clone the repository into your local file system
$ git clone https://github.com/YOUR_USERNAME/library-app.git

# Go to the installed folder
$ cd library-app
```

To install the required ruby gems and dependencies:

```bash
# run the gem install
$ bundler install
```

### Configure the environment variables

There is a file example with the required variables, copy it and adjust the values that fits your environment.

```bash
# Copy the current .env file example
$ cp .env.example .env
```

### Setup the database

Make sure you have confugured the database credentials and postgre server running

```bash
# Create the database and load the schema
$ rake db:setup
```

## Running Tests

This project uses rspec for the tests, to run all the suite just type:

```bash
$ rspec
# Or
$ bundle exec rspec
```

## Code Quality

```bash
# To run linters
$ bundle exec rubocop

# Security check
$ bundle exec brakeman

# Dependencies audit
$ bundle exec bundle-audit

```

## Roles & Permisions

- Admin → Full access `admin@example.com / password123`
- Librarian → Manage books, authors, genres, and book copies `librarian@example.com / password123`
- Member → Browse books and manage their own loans `member@example.com / password123`
