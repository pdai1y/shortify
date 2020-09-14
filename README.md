# Shoritfy

Shortify is a Ruby JSON API that provides URL shortening capabilities. It was built with the intention of being a fast, performant and scalable service.

##### Prerequisites
- Ruby 2.6.3
- MySQL

##### Setup & Tests
- Edit the `config/database.yml` to include your database username, password and any host if applicable
- Create the test database with `RACK_ENV=test rake db:create`
- Then run migrations with `RACK_ENV=test rake db:migrate`
- Tests can simply be run with `rspec`

**Note:** The `RACK_ENV` environment variable can be used with `development` to run the server locally. Once created & migrated, you may run the server using the `puma` command. By default this will run on http://localhost:9292 and you can interact with it using a service like Postman.

##### Endpoints
I kept the routes as simple and straightforward as possible.

By default, making a request to the root of the application with a slug will redirect to the slugs URL as long as it exists. The root endpoint is the only endpoint which returns a text body, all others will return a JSON response. This was done to have some indication there was an issue to the enduser.

| Endpoint   | Params                              | Required Param | HTTP Method |
|------------|-------------------------------------|----------------|-------------|
| /          | :slug (String)                      | :slug          | GET         |
| /api/slugs | {'name': 'string', 'url': 'string'} | 'url'          | POST        |
| /api/slugs | {'name': 'string'}                  | 'name'         | DELETE      |


##### About
I had chosen Roda as it's a performant routing framework with Sequel as the ORM to the database layer. I didn't opt to use something like Rails, Sinatra or Padrino as I wanted the ability to keep things as minimal as possible with a low overhead. Overall, I'm pretty satisfied with the choices I made with these frameworks.

In an effort to keep things relatively similar to those familiar with Rails, I organized the application as closely to what a standard Rails app would look like. The main application is within the `config.ru` and all supplementary files are organized according to thier function. I chose to not include any code preloaders/reloaders like Spring or rack-unreloader for the developement cycle as I wanted to keep the codebase as lean as possible & rely on the webserver/orms fast performance.

As much was done in pure Ruby/Sequel as possible with the exception of the [babosa](https://github.com/norman/babosa) gem. I used this gem to assist in the generation of human readable slugs. This was done in the event a user supplied mulitple strings to the endpoint along with the possiblity of UTF-8 characters being submitted.
