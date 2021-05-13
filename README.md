# Orcheya

## Get started with docker

[Install Docker Engine](https://docs.docker.com/engine/installation/)

[Install Docker Compose](https://docs.docker.com/compose/install/)

### Non Docker way
#### 1. Install Ruby 2.5.1

[Install RVM](https://rvm.io/rvm/install)

After installing go to project directory and install 2.5.1 ruby version

#### 2. Install PostgreSQL 9.6.5

Just example:
```
sudo apt-get install postgresql postgresql-contrib
sudo -u postgres psql
```
Create a user and grant access on database
```sql
CREATE USER orcheya WITH password 'qwerty';
CREATE DATABASE "orcheya_server_development";
CREATE DATABASE "orcheya_server_test";
GRANT ALL PRIVILEGES ON DATABASE "orcheya_server_development" to orcheya;
GRANT ALL PRIVILEGES ON DATABASE "orcheya_server_test" to orcheya;
ALTER USER orcheya createdb;
```

#### 3. Install dependencies programs
[ImageMagick](https://www.imagemagick.org/script/download.php)

[Redis](https://redis.io/download)

#### 4. Install gems
```
gem install bundler
bundle install --path=vendor/bundle
```
#### 5. Create the databases
```
bundle exec rake db:setup
```

**User credentials**
login: `admin@roonyx.tech`
password: `123456`

#### 6. Setup integrations (optional)
##### Slack
1. [Register Slack app](https://api.slack.com/apps)
2. Copy `Client ID` from `Basic Information` to `slack_client_id` on `secrets.yml`
3. Copy `Client Secret` from `Basic Information` to `slack_client_secret` on `secrets.yml`
4. Copy `Bot User OAuth Access Token` from `OAuth & Permissions` to `slack_api_token` on `secrets.yml`
5. Copy slack channel id from url to `slack_channel` on `secrets.yml`
6. Create bot in `Bot User` and turn on `Always Show My Bot as Online`
7. Add in `OAuth & Permissions` -> `Redirect URLs`, for example: `http://localhost:4200/api/integration/slack/callback`
8. Add in `Slash Commands` -> `/update` command, for example: `https://<HOST>/api/integration/slack/slash`
9. Add in `Interactive Components` one url to 2 places: `Interactivity`, `Message Menus`. Url for example: `https://<HOST>/api/integration/slack/action`
10. Turn on `Event Subscriptions`, add in `Enable Events` -> `Request URL`, for example `https://<HOST>/api/integration/slack/event` and add `message.im` into `Subscribe to Bot Events`. This row you must do it after start server.

##### TimeDoctor
1. [Register TimeDoctor app](https://webapi.timedoctor.com/app)
2. Add Redirect URL: `http://<HOST>/api/integration/timedoctor/callback`
3. Copy `client id` to `timedoctor_client_id` on `secrets.yml`
4. Copy `secret key` to `timedoctor_client_secret` on `secrets.yml`

#### Usage

You need to run postgres demon
*Just example for mac* `postgres -D /usr/local/var/postgres`

#### Run server
```
bundle exec rails s
```

#### Run sidekiq
```
bundle exec sidekiq
```

#### Run tests
```
bundle exec rspec
```

#### Run linter
```
bundle exec rubocop
```

#### Generate swagger documentation
```
bundle exec rake swaggerize
```
**Warning!** Don't use the command `rake rswag:specs:swaggerize`. There is a problem with the flag `--dry`

#### Load abilities from `config/permissions.yml` to DB
```
bundle exec rake permissions:load
```

## How to debug?

1. Add breakpoint
2. Run code with breakpoint
3. Attach to orcheya container
```sh
docker attach orcheya_orcheya_1
```
4. Try debug


### How to connect gitlab webhook?
1. Go to https://gitlab.roonyx.team/admin/hooks
2. Add url http//orcheya.com/api/integration/gitlab/push_event
3. Write some phrase in secret token field and also put this token into `config/secret.yml` (`gitlab_secret_token`)
4. Mark `Push events` 
5. Save

## Rules for creating pr
* Creating new routes or changing params in old routes, we **must** add changing to swagger
* Creating difficult or complex libs require unit tests
* All routes require integration tests
* Of course, the code must passes linter and specs

## Features

* [ActiveModel::Serializer](https://github.com/rails-api/active_model_serializers) - Fast serializer
* [FactoryBot](https://github.com/thoughtbot/factory_bot) - A library for setting up Ruby objects as test data.
* [Faker](https://github.com/stympy/faker) A library for generating fake data such as names, addresses, and phone numbers.
* [Guard](http://guardgem.org) - Guard is a command line tool to easily handle events on file system modifications.
* [Pundit](https://github.com/varvet/pundit) - Minimal authorization through OO design and pure Ruby classes
* [RSpec](http://rspec.info) - Behaviour Driven Development for Ruby.
* [Rubocop](http://rubocop.readthedocs.io) - A Ruby static code analyzer, based on the community [Ruby style guide](https://github.com/bbatsov/ruby-style-guide).
* [Sidekiq](https://sidekiq.org/) - Simple, efficient background processing for Ruby.

## Documentation

[Ruby style guide](https://github.com/bbatsov/ruby-style-guide)
