require "./jsonfeed/*"
require "json"

module JSONFeed
  struct Author
    JSON.mapping(
      name: {type: String, nilable: true},
      url: {type: String, nilable: true},
      avatar: {type: String, nilable: true},
    )

    def initialize(@name : String? = nil, @url : String? = nil, @avatar : String? = nil)
    end
  end

  struct Hub
    JSON.mapping(
      _type: String,
      url: String,
    )
  end

  alias Hubs = Array(Hub)

  struct Attachment
    JSON.mapping(
      url: String,
      mime_type: String,
      title: {type: String, nilable: true},
      size_in_bytes: {type: Int32, nilable: true},
      duration_in_seconds: {type: Int32, nilable: true},
    )

    def initialize(@url : String, @mime_type : String, @title : String?, @size_in_bytes : Int32?, @duration_in_seconds : Int32?)
    end
  end

  alias Attachments = Array(Attachment)

  struct Item
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

  struct Feed
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

    def <<(item : Item)
      @items << item
    end
  end

  def self.from_json(json : String)
    JSONFeed::Feed.from_json(json)
  end
end
