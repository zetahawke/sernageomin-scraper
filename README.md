# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  - 2.5.1

* System dependencies
  - Postgresql
  - Redis

* Configuration
  - bundle install

* Database creation
  - rails db:create

* Database initialization
  - rails db:migrate

* How to run the test suite
  - not required

* Services (job queues, cache servers, search engines, etc.)
  - bundle exec sidekiq

* Deployment instructions
  - not especified

  ===

* Endpoints

## Entry Endpoints
### Create
---
entries/init_scrap POST
- require: 
- - headers:
- - body:
``` 
{
	"url": "http://sitiohistorico.sernageomin.cl/mineria-c-exploracion.php",
	"region": 1, 
	"page": 1
}
```
---

### Completed
---
entries/completed_records GET
- require: 
- - headers:
- - params: { page: 1, per_page: 25 }
- - body:
---

### Empty
---
entries/empty_records GET
- require: 
- - headers:
- - params: { page: 1, per_page: 25 }
- - body:
---
