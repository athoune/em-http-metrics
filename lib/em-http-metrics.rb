module EventMachine
  class Metrics < Array
  end

  module Middleware
    class Metrics

      def initialize(metrics)
        @metrics = metrics
        puts "initialized"
        @conn = {}
      end

      def request(client, head, body)
        @conn[client.hash] = Time.new
        [head, body]
      end

      def response(resp)
        timestamp = Time.new
        t = timestamp - @conn[resp.hash]
        @metrics << {
          :time      => t,
          :timestamp => timestamp,
          :status    => resp.response_header.status
        }
        resp
      end

    end
  end
end
