# actionHero-mongoskin
## MongoDB initializers for actionHero backed by MongoSkin

<strong><em>**WORK IN PROGRESS</em></strong>

- [What & Why](#what-why)
- [How to](#how-to)
- [Extend](#extend)
- [Database Seed](#seed)
- [Configuration](#configuration)
- [Exposed API](#exposed-api)

<a name='what-why'></a>

## What & Why
[actionHero.js](http://www.actionherojs.com) is a great toolkit for making **reusable** & **scalable** APIs. actionHero-mongoskin provides a simple initializer that exposes MongoDB support, which is not provided as a default in actionHero.js, via [MongoSkin](https://github.com/kissjs/node-mongoskin). It's also as a prove of concepts of how easy actionHero.js to extend as shown below.

<a name='how-to'></a>

## How to
The easiest way is to install this package via npm and save it as dependency to your actionHero project.

```
npm install actionHero-mongoskin --save
```

Create an initializer, require `actionHero-mongoskin` then expose your initializer with `mongoinit`

```javascript
// initializers/mongodb.js
mongo = require('actionHero-mongoskin').mongoinit;

exports.mongodb = mongo
```

That's it! Now you can access various mongoskin reference from `api.mongo.*` as listed in [Exposed API](#exposed-api).

<a name='extend'></a>

## Extend or override the initializer
You can also extend the default `api.mongo.*` to your liking.
For that you need to manually expose your initializer rather than using actionHero-mongoskin built-in initializer as shown above.

```javascript
// initializers/mongodb.js
mongo = require('actionHero-mongoskin').mongo;

exports.mongodb = function(api, next) {
  // Add a collection object shortcut:
  mongo.mycollection = mongo.db.collection('mycollection');
  api.mongo = mongo; // Now you can access `mycollection` by using `api.mongo.mycollection`
  return next();
};
```

<a name='seed'></a>

## Database Seeding
By default the initializer will also run database seed in server start, useful for providing sample data in development time. All you need to do is override the `api.mongo.dbSeed` function to setup the database.

```javascript
// initializers/mongodb.js
mongo = require('actionHero-mongoskin').mongo;

exports.mongodb = function(api, next) {
  mongo.dbSeed = function(next) {
    api.mongo.collection('mycollection').insert({foo:'bar'}, function(error, result) {
      // ... further setup
      next() // <- IMPORTANT, dont forget to call this when you've finished seeding the database.
    })
  }
  api.mongo = mongo;
  return next();
};
```

If you don't want to run the dbSeed, set the `seed` config option of `mongo` section to `false`. See Configuration explanation below.

<a name='configuration'></a>

## Configuration
To provide connection configuration you need to add `mongo` property to your `config.js` file. Shown below is the default value if no `configData.mongo` available in configuration

```javascript
configData.mongo = {
  // Run database seed if `true`. Set to `false` in production.
  seed: true,
  host: "localhost",
  port: 27017,
  db: "test",
  user: "",
  pass: ""
}
```

<a name='exposed-api'></a>

## Exposed API
### api.mongo.db
### api.mongo.collection
### api.mongo.toId
### api.mongo.ObjectId / api.mongo.ObjectID
### api.mongo.Timestamp
### api.mongo.router
### api.mongo.Cursor
### api.mongo.GridStore
