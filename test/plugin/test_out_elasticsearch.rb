require 'helper'

class ElasticsearchOutputTest < Test::Unit::TestCase

  CONFIG_OUT_KEYS = %[
    host localhost
    port 9200
    index fluent_es_test
  ]

  def setup
    d = create_driver(CONFIG_OUT_KEYS)
    @es_client = Elasticsearch::Client.new hosts: ["#{d.instance.host}:#{d.instance.port}"]

    if @es_client.indices.exists index: d.instance.index
      @es_client.indices.delete index: d.instance.index # remove the test index 
    end
  end

  def create_driver(conf=CONFIG_OUT_KEYS, tag='test-tag')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::ElasticsearchOutput, tag).configure(conf)
  end

  def test_configure
    d = create_driver(CONFIG_OUT_KEYS)

    assert_equal "localhost", d.instance.host
    assert_equal 9200, d.instance.port
    assert_equal "fluent_es_test", d.instance.index
  end

  def test_indexing
    d = create_driver(CONFIG_OUT_KEYS)
    d.emit({"hello" => "world"})
    d.emit({"why" => "not"})
    d.run

    # give elasticsearch time to index documents (should be under integration testing?)
    sleep 2    
    puts "#{@es_client.search index: d.instance.index}"
    count_result = @es_client.count index: d.instance.index
    assert_equal 2, count_result["count"]
  end

end

