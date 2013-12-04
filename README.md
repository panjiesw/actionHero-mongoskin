# actionHero-mongoskin
## MongoDB initializers for actionHero backed by MongoSkin

__*WORK IN PROGRESS*__

## What & Why
[actionHero.js](http://www.actionherojs.com) is a great toolkit for making **reusable** & **scalable** APIs. actionHero-mongoskin provides a simple initializer that exposes MongoDB support, which is not provided as a default in actionHero.js, via [MongoSkin](https://github.com/kissjs/node-mongoskin). It's also as a prove of concepts of how easy actionHero.js to extend as shown below.

## How to
The easiest way is to install this package via npm and save it as dependency to your actionHero project.

```
npm install actionHero-mongoskin --save
```

Create an initializer, require `actionHero-mongoskin` then expose your initializer with `mongoinit`

```javascript
// initializers/mongodb.js
mongo = require('actionHero-mongoskin');

exports.mongodb = mongo.mongoinit
```

That's it! Now you can access various mongoskin reference from `api.mongo.*` as listed below.
