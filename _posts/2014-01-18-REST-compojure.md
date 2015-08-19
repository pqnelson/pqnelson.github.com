---
layout: post
title: Oddball HTTP Requests in Compojure
published: true
quote: "To obey a rule, to make a report, to give an order, to play a game of chess, are <em>customs</em>."
quoteSource: Ludwig Wittgenstein, <em>Philosophical Investigations</em> &sect;199
tags: [REST]
---
As a web-developer coding in Clojure, I want to use 
[Compojure](https://github.com/weavejester/compojure) 
and Ring, specifically to handle various
RESTful situations. But how can I write a `PUT` Compojure route, and
jQuery AJAX request? It was trickier than it seems, and no one really
seems to discuss it.

There are three things to examine: the Compojure routes, the Ring
middleware, and the jQuery requests. Lets consider them in turn, then
put them all together for a minimal working (toy) example.

## Compojure Methods

Compojure routes are beautifully simple. Setting up `PUT` or `DELETE`
routes reduce to a triviality at this stage. So we may set up some toy
Compojure routes: 

```clojure
(ns rest-example.routes
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [rest-example.book :as book]))

(defroutes app
  (GET "/" [] "<h1>Hello World!</h1>")
  (PUT "/books/:id" r (book/put-book r))
  (DELETE "/books/:id" r (book/delete-book r))
  (GET "/books/:id" r (book/get-book r)))
```

## Ring Difficulties

The Ring middleware is actually (surprisingly) straightforward:

```clojure
(ns rest-example.middleware
  (:require [ring.middleware.params :refer :all]
            [ring.middleware.keyword-params :refer :all]))

(defn my-middleware [routes]
  (-> routes
      wrap-keyword-params
      wrap-params)) ;; whatever else you do should be appended
```

## jQuery Requests

So, the jQuery request for a `PUT`, `PATCH`, or `DELETE` should look
like:

```javascript
$.ajax({url: url, type: "DELETE", /* ... */});
```

But if you don't want to repeat yourself over and over and over, you can
add a few lines of Javascript extending jQuery (c.f., lines 8273 of
`jquery-1.10.2.js` for example):

```javascript
function _ajax_request(url, data, callback, type, method) {
    // shift arguments if data argument was omitted
    if ( jQuery.isFunction( data ) ) {
        type = type || callback;
        callback = data;
        data = undefined;
    }

    return jQuery.ajax({
        url: url,
        type: method.toUpperCase(),
        dataType: type,
        data: data,
        success: callback
    });
};
jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, "put");
    },
    patch: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, "patch");
    },
    delete: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, "delete");
    }
});
```

This will allow you to write lines of code like `$.delete(url)`, and so
on. So there will be no need to repeat yourself

### Puzzle

The non-standard requests (e.g., `PUT`, `PATCH`, `DELETE`, and friends)
are trickier to handle since browsers do not universally support
them. 

What [Compojure does](https://github.com/weavejester/compojure/blob/master/src/compojure/core.clj#L19)
is quite simple: simply do a `POST` request, with the `:form-params`
have a field `"_method"` which is `"patch"`, `"put"`, or `"delete"` (or
whatever request you want).

Compojure routes check the `form-params`, which in turn checks the
`_method` in the HTTP request body. Is there some way to add in
`_method: DELETE` (or `PUT` or...) directly in jQuery?

*Remark.* This would actually cause problems with Internet Explorer
 browsers if we don't solve this puzzle. (End of Remark)

## Combining Everything Together

So, now we have our `core.clj` which looks like:

```clojure
(ns rest-example.core
  (:require [ring.adapter.jetty :refer :all]
            [rest-example.routes :as routes]
            [rest-example.middleware :as middleware]))

(def routes (middleware/my-middleware routes/app))

(defn -main []
  (run-jetty #'rest-example/routes {:port 8080}))
```

The complete working code (which really works!) is
[available](https://github.com/pqnelson/rest-example). 
