Em-Http-Metrics
===============

Keeps some data of http request.

Em-Http-Metrics is a middleware for em-http-request.

Values are kept in RAM, but you can handle it, to do some math, or export it, to use an other tool to find som meaning in all this numbers.

Use it
------

Metrics class handle all the values. The middleware is easy to use : you can use it on a specific connection, or globaly.
```ruby
m = Metrics::Metrics.new
EM::HttpRequest.use EventMachine::Middleware::Metrics, m
```
Do some requests.

You can export it as a CSV :
```ruby
require "em-http-metrics/csv"

puts m.to_csv.string
```

Licence
-------

LGPL.
