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


describe EventMachine::Metrics do
  it "fetch a simple page" do
    EM.run do
      m = EM::Metrics.new
      c = Counter.new 2 do
        EM.stop
        p m
      end
      EM::HttpRequest.use EventMachine::Middleware::Metrics, m

      google = EventMachine::HttpRequest.new('http://google.com/')
      hg = google.get
      hg.errback { p 'Uh oh'; EM.stop }
      hg.callback do
        p "google", hg.response_header.status
        c.next
      end

      yahoo = EventMachine::HttpRequest.new 'http://yahoo.com'
      hy = yahoo.get
      hy.errback { p 'Yahoo Uh oh'; EM.stop }
      hy.callback do
        p "yahoo", hy.response_header.status
        c.next
      end

    end
  end
end
