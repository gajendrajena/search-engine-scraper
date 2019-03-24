# Search Engine Scraper
A google scraper to search in google

Implementations

## Allow users to upload a csv file of keywords to search
## Parse the csv file to find the keywords
## for each keyword triggering a worker to scrape
## Worker creates an instance of the search engine scraper and scrape with the keyword
## Sidekiq worker should try repeated search in case of search failure
## Store the scrape results in database

## Technologies
- Frontend
`HTML`, `CSS`, `Javascript`, `JQuery`, `Twitter Bootstrap (4.3.1)`

- Backend
`Ruby on Rails` ( Ruby:` 2.6.0`, Rails: `5.2.2.1`, Sidekiq: `5.2.5`, Redis )

## Pre requisite
1. Ruby - `2.6.0` ( Choose `rvm` or `rbenv` )

2. Redis
`brew install redis`

3. Postgresql - `10.7`
`brew install postgresql`
`brew services start postgresql`

## Setup

**1. Clone the repository**
```
git clone git@github.com:gajendrajena/search-engine-scraper.git
```

**2. Install Dependencies**
```
cd search-engine-scraper
bundle install
```

**3. Create Database**

```
rake db:create
```

**4. Setup seed data**

```
rake db:setup
```

**5. Run server**

```
rails s
```
```
redis-server
```
```
bundle exec sidekiq
```


**6. To run testcases**

```
bundle exec rspec
```


## Deployment

Platform - `Heroku`

This application is currently deployed at https://search-engine-scraper.herokuapp.com/


## Credits

Gajendra Jena
