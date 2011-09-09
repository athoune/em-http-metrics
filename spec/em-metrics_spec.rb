require "minitest/autorun"
require "em-http-request"
require "em-http-metrics"

class Counter
  def initialize times, &block
    @times = times
    @cb = block
  end

  def next
    @times -= 1
    @cb.call if @times == 0
  end
end


describe Metrics do
  it "fetch a simple page" do
    EM.run do
      m = Metrics::Metrics.new

      SITES = %w{www.google.com www.bing.com www.yahoo.com duckduckgo.com}

      c = Counter.new SITES.length do
        EM.stop
        puts m
      end
      EM::HttpRequest.use EventMachine::Middleware::Metrics, m

      SITES.each do |site|
        conn = EventMachine::HttpRequest.new "http://#{site}"
        http = conn.get
        http.errback  { p '#{site} : Uh oh'; EM.stop }
        http.callback { c.next }
      end
    end
  end
end
