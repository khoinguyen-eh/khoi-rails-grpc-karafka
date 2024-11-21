# frozen_string_literal: true

module Grpc
  module Dsl
    def self.extended(klass)
      Grpc::Handler.add_base_handler_class(klass)
    end
  end
end
