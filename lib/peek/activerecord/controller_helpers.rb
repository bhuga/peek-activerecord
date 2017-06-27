begin
  require 'pygments.rb'
rescue LoadError
  # Doesn't have pygments.rb installed
end

require "rack/utils"

module Peek
  module ActiveRecord
    module ControllerHelpers
      extend ActiveSupport::Concern

      included do
        around_action :inject_peek_activerecord, :if => [:peek_enabled?, :peek_activerecord_enabled?]
      end

      protected

      def pygments_enabled?
        defined?(Pygments)
      end

      def pygmentized_sql(sql)
        if pygments_enabled?
          Pygments.highlight(sql, :lexer => 'sql')
        else
          "#{Rack::Utils.escape_html(code)}"
        end
      end

      # This can be overwritten in ApplicationController to disable query
      # tracking separately from peek
      def peek_activerecord_enabled?
        peek_enabled?
      end

      def inject_peek_activerecord(&block)
        puts "injecting"
        return block.call unless peek_activerecord_enabled?
        ret = nil
        queries = []
        subscriber = ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
          event = ActiveSupport::Notifications::Event.new *args
          queries << event
        end
        ret = block.call
        peek_activerecord_append_queries_to_response(queries)
        ret
      ensure
        ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
      end

      def peek_activerecord_append_queries_to_response(queries)
        if response.content_type =~ %r|text/html|
          output = <<-EOS
            <div class=ar_instrumentation id=peek_activerecord_table>
            <ul>
              <li>
                <ul class=row>
                  <li class=duration-header>
                    Duration
                  </li>
                  <li class=cached-header>
                    Cached
                  </li>
                  <li class=sql-header>
                    SQL
                  </li>
                </ul>
              </li>
          EOS
          queries.each do |query|
            output << <<-EOS
              <li>
                <ul class=row>
                  <li class=duration-data>
                    #{"%.3f" % query.duration}ms
                  </li>
                  <li class=cache-data>
                    #{query.payload[:name] == "CACHE"}
                  </li>
                  <li class=sql-data>
                    #{pygmentized_sql(query.payload[:sql])}
                  </li>
                </ul>
              </li>
            EOS
          end
          output << "</table>"
          response.body += "<div id='peek-activerecord-modal'>#{output}</div>".html_safe
        end
      end
    end
  end
end
