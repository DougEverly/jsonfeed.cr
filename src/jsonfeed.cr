require "./jsonfeed/*"
require "json"

module JSONFeed
  module Builder
    def build(**args)
      new(**args).tap do |b|
        yield b
      end
    end
  end

  class Author
    extend JSONFeed::Builder
    JSON.mapping(
      name: {type: String, nilable: true},
      url: {type: String, nilable: true},
      avatar: {type: String, nilable: true},
    )

    def initialize(@name : String? = nil, @url : String? = nil, @avatar : String? = nil)
    end

    def ==(other)
      other &&
        name == other.name &&
        url == other.url &&
        avatar == other.avatar
    end
  end

  class Hub
    JSON.mapping(
      _type: String,
      url: String,
    )

    def ==(other)
      _type == other._type &&
        url == other.url
    end
  end

  alias Hubs = Array(Hub)

  class Attachment
    extend JSONFeed::Builder
    JSON.mapping(
      url: String,
      mime_type: String,
      title: {type: String, nilable: true},
      size_in_bytes: {type: Int32, nilable: true},
      duration_in_seconds: {type: Int32, nilable: true},
    )

    def initialize(@url : String, @mime_type : String, @title : String?, @size_in_bytes : Int32?, @duration_in_seconds : Int32?)
    end

    def ==(other)
      url == other.url &&
        mime_type == other.mime_type &&
        title == other.title &&
        size_in_bytes == other.size_in_bytes &&
        duration_in_seconds == other.duration_in_seconds
    end
  end

  alias Attachments = Array(Attachment)

  class Item
    extend JSONFeed::Builder
    JSON.mapping(
      id: String,
      url: {type: String, nilable: true},
      external_url: {type: String, nilable: true},
      title: {type: String, nilable: true},

      content_html: {type: String, nilable: true}, # one or both
      content_text: {type: String, nilable: true}, # one or both

      summary: {type: String, nilable: true},
      image: {type: String, nilable: true},
      banner: {type: String, nilable: true},
      date_published: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%dT%H:%M:%S%:z")}, # RFC 3339 2010-02-07T14:04:00-05:00
      date_modified: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%dT%H:%M:%S%:z")},  # RFC 3339 2010-02-07T14:04:00-05:00
      author: {type: Author, nilable: true},
      tags: {type: Array(String), nilable: true},
      attachments: {type: Array(Attachment), nilable: true},
    )

    def ==(other)
      id == other.id &&
        url == other.url &&
        external_url == other.external_url &&
        title == other.title &&
        content_html == other.content_html &&
        content_text == other.content_text &&
        summary == other.summary &&
        image == other.image &&
        banner == other.banner &&
        date_published == other.date_published &&
        date_modified == other.date_modified &&
        author == other.author &&
        tags == other.tags &&
        attachments == other.attachments
    end

    def date_published=(date : String)
      @date_published = Time::Format.new("%Y-%m-%dT%H:%M:%S%:z").parse(date)
    end

    def date_modified=(date : String)
      @date_modified = Time::Format.new("%Y-%m-%dT%H:%M:%S%:z").parse(date)
    end

    def initialize(@id : String, @url : String? = nil, @external_url : String? = nil, @title : String? = nil, @content_html : String? = nil, @content_text : String? = nil, @summary : String? = nil, @image : String? = nil, @banner : String? = nil, date_published : Time | String | Nil = nil, date_modified : Time | String | Nil = nil, @author : Author? = nil, @tags : Array(String)? = nil, @attachments : Attachments? = nil)
      @date_modified = case date_modified
                       when Time
                         date_modified
                       when String
                         Time::Format.new("%Y-%m-%dT%H:%M:%S%:z").parse(date_modified)
                       end
      @date_published = case date_published
                        when Time
                          date_published
                        when String
                          Time::Format.new("%Y-%m-%dT%H:%M:%S%:z").parse(date_published)
                        end
    end
  end

  alias Items = Array(JSONFeed::Item)

  class Feed
    extend JSONFeed::Builder
    # extend JSONFeed::Builder
    JSON.mapping(
      version: String,
      title: String,
      home_page_url: {type: String, nilable: true},
      feed_url: {type: String, nilable: true},
      description: {type: String, nilable: true},
      user_comment: {type: String, nilable: true},
      next_url: {type: String, nilable: true},
      favicon: {type: String, nilable: true},
      author: {type: Author, nilable: true},
      expired: {type: Bool, nilable: true, default: false},
      hubs: {type: Array(Hub), nilable: true},
      items: Items,
    )

    def initialize(@version : String, @title : String, @home_page_url : String? = nil, @feed_url : String? = nil, @description : String? = nil, @user_comment : String? = nil, @next_url : String? = nil, @favicon : String? = nil, @author : Author? = nil, @expired : Bool? = false, @hub : Hubs? = nil, @items : Items = Items.new)
    end

    def ==(other)
      version == other.version &&
        title == other.title &&
        home_page_url == home_page_url &&
        feed_url == other.feed_url &&
        user_comment == other.user_comment &&
        next_url == other.next_url &&
        favicon == other.favicon &&
        author == other.author &&
        expired == other.expired &&
        hubs == other.hubs &&
        items == other.items
    end

    def <<(item : Item)
      @items << item
    end
  end

  def self.from_json(json : String)
    JSONFeed::Feed.from_json(json)
  end
end
