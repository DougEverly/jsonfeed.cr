require "../jsonfeed"
require "http/client"

def json_local
  path = __DIR__ + "/../examples/blog.json"
  File.read(path)
end

def podcast
  path = __DIR__ + "/../examples/podcast.json"
  File.read(path)
end

def ext
  path = __DIR__ + "/../examples/podcast_extension.json"
  File.read(path)
end

def microblog
  path = __DIR__ + "/../examples/microblog.json"
  File.read(path)
end

def http
  url = "https://jsonfeed.org/feed.json"
  r = HTTP::Client.get url
  r.body
end

feed = JSONFeed.from_json(http)

pp feed
