# jsonfeed

Crystal implementation of JSONFeed spec.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  jsonfeed:
    github: DougEverly/jsonfeed
```

## Usage

See examples/ and spec/ for usage examples.

### Loading JSONFeed
```crystal

require "jsonfeed"

url = "https://jsonfeed.org/feed.json"
r = HTTP::Client.get url
r.body

feed = JSONFeed.from_json(r.body)

pp feed
```

## Generating JSONFeed

### Using the Builder
```crystal
require "jsonfeed"

feed = JSONFeed::Feed.build(version: "https://jsonfeed.org/version/1", title: "Brent Simmons’s Microblog") do |feed|
  feed.user_comment = "This is a microblog feed. You can add this to your feed reader using the following URL: https://example.org/feed.json"
  feed.home_page_url = "https://example.org/"
  feed.feed_url = "https://example.org/feed.json"
  feed.author = JSONFeed::Author.build do |author|
    author.name = "Brent Simmons"
    author.url = "http://example.org/"
    author.avatar = "https://example.org/avatar.png"
  end
  feed.items << JSONFeed::Item.build(id: "2347259", url: "https://example.org/2347259") do |item|
    item.content_text = "Cats are neat. \n\nhttps://example.org/cats"
    item.date_published = "2016-02-09T14:22:00-07:00"
  end
end

puts feed.to_json

```

### Using the Initializer
```crystal

require "jsonfeed"

author = JSONFeed::Author.new(name: "Brent Simmons", url: "http://example.org/", avatar: "https://example.org/avatar.png")

feed = JSONFeed::Feed.new(version: "https://jsonfeed.org/version/1", title: "Brent Simmons’s Microblog", user_comment: "This is a microblog feed. You can add this to your feed reader using the following URL: https://example.org/feed.json", home_page_url: "https://example.org/", feed_url: "https://example.org/feed.json", author: author)

item = JSONFeed::Item.new(id: "2347259", url: "https://example.org/2347259", content_text: "Cats are neat. \n\nhttps://example.org/cats", date_published: "2016-02-09T14:22:00-07:00")

feed << item

puts feed.to_json

```


## Development

### TODO

* Extensions not yet supported. Ideally would use https://github.com/crystal-lang/crystal/pull/4411.
* Enforce `content_html` and `content_text`: one or both must be present
* Create a builder for JSONFeed::Feed.

## Contributing

1. Fork it ( https://github.com/DougEverly/jsonfeed/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [DougEverly](https://github.com/DougEverly) Doug Everly - creator, maintainer
