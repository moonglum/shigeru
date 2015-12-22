# Shigeru [![build status](https://travis-ci.org/moonglum/shigeru.svg)](https://travis-ci.org/moonglum/shigeru)

Shigeru helps you with the links and HTTP-URIs in your application. It is supposed to be a simpler version of what Rails offers. It is named after [Shigeru Miyamoto](https://en.wikipedia.org/wiki/Shigeru_Miyamoto), the creator of Link.

**Shigeru is in an experimental phase while we figure out how to offer a simple `uri_for` helper that is agnostic of routing libraries. As it has not reached 1.0 yet, anything can change at any time. As soon as it stabilizes this will be marked by the 1.0 release.**


# Concept

In REST, Fielding defines four interface constraints. One of them is the *identification of resources*. This library tries to simplify that in the scope of an HTTP based web application. In order to do that, Shigeru offers a mapping from a resource to a resource identifier (in our case a URI as we are talking about HTTP based web applications). Fielding states a few examples for what a resource might be:

> Any information that can be named can be a resource: a document or image, a temporal service (e.g. "today's weather in Los Angeles"), a collection of other resources, a non-virtual object (e.g. a person), and so on. In other words, any concept that might be the target of an author's hypertext reference must fit within the definition of a resource.
>   -- Architectural Styles and the Design of Network-based Software Architectures, section 5.2.1.1: Resources and Resource Identifiers - [Roy Thomas Fielding](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_2)

Shigeru does not care about how your URIs look (in the same way that REST doesn't care about that). For Shigeru `/users/12` is as valid as `/createAllTheThings` or `/xaa/12/xhy`. We don't judge you.

In Shigeru, you first define a route. Then you can use this definition throughout your code. For example:

```ruby
require 'shigeru'

routes = Shigeru::Repository.new
routes.define :users, '/users'

# Somewhere later:
routes.uri_for(:users) #=> '/users'
```

Shigeru supports a subset of [URI templates](https://tools.ietf.org/html/rfc6570), Level 4 to make your URIs dynamic. It supports the simple insertion of a parameter:

```ruby
routes.define :user, '/users/{id}'
routes.uri_for(:user, id: 13) #=> '/users/13'
```

It is also possible to explode a parameter (this is noted with a `*` suffix for that variable). It then expects an array instead of a single value:

```ruby
routes.define :users, '/users/{ids*}'
routes.uri_for(:users, ids: [13,15]) #=> '/users/13,15'
```

It is also possible to insert query parameters. To do that, you add a question mark as the first character in your curly braces (we call this the sigil). It is possible to insert one or more variables in one curly brace:

```ruby
routes.define :users, '/users{?name,country}'
routes.uri_for(:users, name: 'alice', country: 'argentina') #=> '/users?name=alice&country=argentina'
```

Finally, we can add route parameters. Again, we can use both explode modifiers as well as multiple parameters in one insertion:

```ruby
routes.define :users, '/users{/xs*}'
routes.uri_for(:users, xs: ['alice', 'bob']) #=> '/users/alice/bob'
```

## Design

The implementation of Shigeru is inspired by [Michel Martens](https://github.com/soveran)' [mote](https://github.com/soveran/mote) and the [codalyzed video about it](https://codalyzed.com/videos/lesscode). It trades performance (only executing a proc when calling `uri_for` that doesn't need to parse the template) against a slightly hairy implementation (building Ruby code by String concatenation and `eval`ing it :scream:).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/moonglum/shigeru). You can find more information about contributing in the [CONTRIBUTING.md](https://github.com/moonglum/shigeru/blob/master/CONTRIBUTING.md). This project is intended to be a safe, welcoming space for collaboration and discussion, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
