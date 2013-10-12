# encoding: UTF-8

class Fluent::ElasticsearchOutput < Fluent::BufferedOutput
  # register plugin first.  
  attr_reader :es
  Fluent::Plugin.register_output('elasticsearch', self)

  config_param :host,  :string,  :default => 'localhost'
  config_param :port,  :integer, :default => 9200
  config_param :index, :string, :default => "fluentd"

  def initialize
    require 'elasticsearch'
    super
  end

  def configure(conf)
    super
  end

  def start
    super
    es_url = "#{self.host}:#{self.port}"
    puts "es_url: #{es_url}"
    @es = Elasticsearch::Client.new hosts: [es_url]
  end

  def shutdown
    super
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def write(chunk)
    puts "chunk - #{chunk.inspect}"
    bulk_items = []

    chunk.msgpack_each do |tag, time, record|
      puts "#{tag} #{time} #{record}"
      bulk_items << {
        :index => { 
          :_index => self.index,
          :_type => tag,
          :data => {
            :tag  => tag,
            :time => time,
            :record => record
          }
        }
      }
    end

    ## now bulk index
    puts "bulk_items - #{bulk_items.inspect}"
    @es.bulk :index => self.index, :body => bulk_items
  end
  ##--
end

