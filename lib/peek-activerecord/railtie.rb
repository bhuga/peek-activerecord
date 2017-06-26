require 'peek/activerecord/controller_helpers'

module Peek
  module ActiveRecord
    class Railtie < ::Rails::Engine
      initializer 'peek.activerecord.include_controller_helpers' do
        ActiveSupport.on_load(:action_controller) do
          include Peek::ActiveRecord::ControllerHelpers
        end
      end
    end
  end
end
