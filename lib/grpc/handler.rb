# frozen_string_literal: true

module Grpc
  class Handler
    class << self
      def add_base_handler_class(klass)
        key = klass.name.split('::').last.delete_suffix('Handler')
        @handlers ||= {}
        @handlers[key] ||= klass
      end

      def handler
        Class.new(Files::RpcServer::Service) do
          define_method(:handlers) do
            @handlers ||= Grpc::Handler.instance_variable_get(:@handlers).with_indifferent_access
          end

          Files::RpcServer::Service.rpc_descs.each_key do |name|
            method_name = name.to_s.gsub(/(.)([A-Z])/, '\1_\2').downcase
            define_method(method_name) do |*args|
              handler = handlers[name].new(*args)
              handler.call
            end
          end
        end
      end
    end
  end
end
