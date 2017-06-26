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
          Pygments.highlight(sql, :lexer => sql)
        else
          "<pre>#{Rack::Utils.escape_html(code)}</pre>"
        end
      end

      # This can be overwritten in ApplicationController to disable query
      # tracking separately from peek
      def peek_activerecord_enabled?
        peek_enabled?
      end

      def inject_peek_activerecord(&block)
        ret = nil
        queries = []
        ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
          event = ActiveSupport::Notifications::Event.new *args
          queries << event
          ret = block.call
        end
        if response.content_type =~ %r|text/html|
          output = <<-EOS
            <div class=ar_instrumentation>
            <table>
              <tr>
                <th>
                  Duration
                </th>
                <th>
                  Cached
                </th>
                <th>
                  SQL
                </th>
              </tr>
          EOS
          queries.each do |query|
            output << <<-EOS
              <tr>
                <td>
                  #{query.duration}ms
                </td>
                <td>
                  #{query.payload[:name] == "CACHE"}
                </td>
                <td>
                  #{pygmentized_sql(query.payload[:sql])}
                </td>
              </tr>
            EOS
          end
          output << "</table>"
          response.body += "<div class='peek-activerecord-modal'>#{output}</div>".html_safe
        end
        ret
      end
    end
  end
end
