# README

To set Heroku env vars (from `config/application.yml`):
`figaro heroku:set -e production --app sales-marketing`

Database environment variables:
In order to user your local database, the database environment variables should be configured. First, execute the next command on the project root folder:

  $bundle exec figaro install

The file "application.yml" should now be on your "config" folder. Inside this file you can create as many environment variables as you want. For the database variable, you should follow the pattern below:

development:
  DATABASE: your_db1
  DATABASE_USER: your_user1
  DATABASE_PASSWORD: your_pass1

test:
  DATABASE: your_db2
  ...

production:
  ...
