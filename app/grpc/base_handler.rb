# frozen_string_literal: true

class BaseHandler
  def self.inherited(subclass)
    super
    subclass.extend Grpc::Dsl
  end

  def initialize(request, meta)
    @request = request
    @meta = meta
  end

  attr_reader :request, :meta

  def call
    raise NotImplementedError, 'This class does not implement a service'
  end
end
