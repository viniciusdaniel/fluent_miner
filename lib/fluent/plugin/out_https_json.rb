class Fluent::HttpsJsonOutput < Fluent::TimeSlicedOutput
  # First, register the plugin. NAME is the name of this plugin
  # and identifies the plugin in the configuration file.
  Fluent::Plugin.register_output('miner', self)

  def initialize
    require 'net/http'
    require 'net/https'
    require 'uri'
    super
  end

  # This method is called before starting.
  # 'conf' is a Hash that includes configuration parameters.
  # If the configuration is invalid, raise Fluent::ConfigError.
  def configure(conf)
    super
    @uri = URI.parse(conf['endpoint'])
    @http = Net::HTTP.new(@uri.host,@uri.port)
    @https = Net::HTTP.new(@uri.host,@uri.port)
    @https.use_ssl = true
    @use_https = conf['use_https'] == 'true'
  end

  # This method is called when starting.
  # Open sockets or files here.
  def start
    super
  end

  # This method is called when shutting down.
  # Shutdown the thread and close sockets or files here.
  def shutdown
    super
  end

  ## Optionally, you can use to_msgpack to serialize the object.
  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  # This method is called every flush interval. Write the buffer chunk
  # to files or databases here.
  # 'chunk' is a buffer chunk that includes multiple formatted
  # events. You can use 'data = chunk.read' to get all events and
  # 'chunk.open {|io| ... }' to get IO objects.
  def write(chunk)
    events = []
    chunk.msgpack_each {|(tag,time,record)|
      events << record
    }
    events = events.to_json
    req = Net::HTTP::Post.new(@uri.path)
    req.set_form_data(events)
    if @use_https
      res = @https.request(req)
    else
      res = @http.request(req)
    end
  end

end