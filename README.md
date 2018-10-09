# WaterAid Gift Shop

## Environments

#### Production:
https://gavoshop.wateraid.se

```
$ heroku git:remote -a wateraid-giftshop
```

#### Staging:
https://wateraid-giftshop-staging.herokuapp.com

```
$ git remote add heroku-staging git@heroku.com:wateraid-giftshop-staging.git
```

## Running locally

1. $ git clone git@github.com:kollegorna/wateraid-giftshop.git
2. $ cd wateraid-giftshop
3. $ bundle install
4. $ bower install
5. $ bin/rake db:create
6. $ bin/rake db:migrate
7. $ foreman start

### Required environment variables

An up to date list of environment variables that is required for the different rails application environments can always be found here:

https://github.com/kollegorna/wateraid-giftshop/blob/master/config/secrets.yml

You will find keys for your ``.envrc`` in [LastPass](https://lastpass.com/). Look for "BG Play".

In most cases you can use the variables the staging environment is using.
To see all the variables run:

$ heroku config --app wateraid-giftshop-staging

## Deploy to production

Only deploy from master branch.

Deploy to production with:
$ git push heroku master

## Deploy to staging

Deploy the feature branch you want.

Deploy to staging with:

`$ git push heroku-staging [NAME-OF-BRANCH]:master --force`


For example to deploy from the staging branch:

`$ git push heroku-staging staging:master --force`

## Using the Heroku toolbelt

When using for example
`$ heroku restart`

We must add a flag for which app we want to restart. Like this:
`$ heroku restart --app wateraid-giftshop`
or
`$ heroku restart --app wateraid-giftshop-staging`

Depending on what's been deployed you might need to do some of the following:

`$ heroku rake db:migrate --app wateraid-giftshop`

`$ heroku restart --app wateraid-giftshop-staging`

## Database dump

### How to create database dump from prod and import it locally:

1. Make a DB snapshot on Heroku.
`$ heroku pg:backups capture --app wateraid-giftshop`

2. Download the dump.
Use this command:

  `$ curl -o latest.dump $(heroku pg:backups url --app wateraid-giftshop)`

3. Import file to PG…

  `$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -d [NAME-OF-LOCAL-DB] latest.dump`

### How to create database dump from prod and import it on staging

Follow step 1 and 2 above, and then:

3. Put latest.dump somewhere download accessible, like Dropbox.

4. Import the dump.

`$ heroku pgbackups:restore HEROKU_POSTGRESQL_COBALT_URL 'http://somewhere-public.yadayada.com/latest.dump' --app wateraid-giftshop-staging`
