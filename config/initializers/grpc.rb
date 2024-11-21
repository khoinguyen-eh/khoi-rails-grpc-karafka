# frozen_string_literal: true

Dir[Rails.root.join('lib/**/*_services_pb.rb')].sort.each do |file|
  require file
end

Dir[Rails.root.join('lib/**/*_pb.rb')].sort.each do |file|
  require file
end

module GRPC
  module RailsLogger
    def logger
      Rails.logger
    end
  end

  extend RailsLogger
end
