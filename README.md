# LIST API

## Features

This Api has the following, and more:

- API Versioning
- Following JSONAPI conventions
- User Authentication using Devise
- User Authorization using CanCan
- Error and Exception Handling
- Rspec Integration Testing
- Rspec Unit Testing

## API HAS THE FOLLOWING RESOURCES
 - User
   - Lists
     - Cards
       - Comments
         - Replies

* Ruby version 2.5.0

* System dependencies
  - [Devise](https://github.com/plataformatec/devise)
  - [CanCanCan](https://github.com/CanCanCommunity/cancancan)
  - [Rspec](https://github.com/rspec/rspec-rails)

* Configuration

* Database creation
Postgresql Database
```
mv config/application-example.yml config/application.yml
```
* Database initialization
```
bundle exec rake db:create && bundle exec rake db:migrate
```
* How to run the test suite
```
bundle exec rspec
```
## Authors

* **Mohamed Hegab** - *Initial work* - [MohamedHegab](https://github.com/MohamedHegab)

