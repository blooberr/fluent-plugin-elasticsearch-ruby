# encoding: UTF-8

class Fluent::ElasticsearchOutput < Fluent::Output
  Fluent::Plugin.register_output('elasticsearch', self)
  config_param :host, :string,  :default => 'localhost'
  config_param :port, :integer, :default => 9200
  config_param :index, :string, :default => "fluentd"

  def initialize
    super
    encoding = Encoding.default_internal
    Encoding.default_internal = nil
    require 'tire'
    Encoding.default_internal = encoding
  end

  def configure(conf)
    super
  end

  def start
    super
    es_url = "http://#{self.host}:#{self.port}"
    Tire.configure do
      url es_url
    end
   
    @es_index = Tire::Index.new(self.index)
  end

  def shutdown
    super
  end

  def emit(tag, es, chain)
    chain.next
    es.each { |time, record|
      @es_index.store :tag => tag, :time => time, :record => record
    }
  end
end

