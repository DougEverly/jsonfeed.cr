require "./spec_helper"

describe JSONFeed do
  it "loads_blog" do
    path = "examples/blog.json"
    data = File.read(path)
    feed = JSONFeed.from_json(data)
    feed.should be_truthy
  end

  it "loads_microblog" do
    path = "examples/microblog.json"
    data = File.read(path)
    feed = JSONFeed.from_json(data)
    feed.should be_truthy
  end

  it "loads_podcast" do
    path = "examples/podcast.json"
    data = File.read(path)
    feed = JSONFeed.from_json(data)
    feed.should be_truthy
  end

  it "creates_new_feed_with_time" do
    author = JSONFeed::Author.new(name: "Brent Simmons", url: "http://example.org/", avatar: "https://example.org/avatar.png")
    feed = JSONFeed::Feed.new(version: "https://jsonfeed.org/version/1", title: "Brent Simmons’s Microblog", user_comment: "This is a microblog feed. You can add this to your feed reader using the following URL: https://example.org/feed.json", home_page_url: "https://example.org/", feed_url: "https://example.org/feed.json", author: author)
    converter = Time::Format.new("%Y-%m-%dT%H:%M:%S%:z")
    item = JSONFeed::Item.new(id: "2347259", url: "https://example.org/2347259", content_text: "Cats are neat. \n\nhttps://example.org/cats", date_published: converter.parse("2016-02-09T14:22:00-07:00"))
    feed << item
    feed.to_json.should be_a(String)
  end

  it "creates_new_feed_with_string" do
    author = JSONFeed::Author.new(name: "Brent Simmons", url: "http://example.org/", avatar: "https://example.org/avatar.png")
    feed = JSONFeed::Feed.new(version: "https://jsonfeed.org/version/1", title: "Brent Simmons’s Microblog", user_comment: "This is a microblog feed. You can add this to your feed reader using the following URL: https://example.org/feed.json", home_page_url: "https://example.org/", feed_url: "https://example.org/feed.json", author: author)
    item = JSONFeed::Item.new(id: "2347259", url: "https://example.org/2347259", content_text: "Cats are neat. \n\nhttps://example.org/cats", date_published: "2016-02-09T14:22:00-07:00")
    feed << item
    feed.to_json.should be_a(String)
  end
end
