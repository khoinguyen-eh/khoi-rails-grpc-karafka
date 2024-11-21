# frozen_string_literal: true

class BaseError < StandardError; end

class FileNotFoundError < BaseError; end

class Base
  def self.call(*args, **kwargs)
    service = new(*args, **kwargs)
    service.call
    service
  end

  def initialize(*_args, **_kwargs)
    @errors = []
  end

  attr_reader :errors, :data

  def success?
    errors.empty?
  end

  def error?
    errors.any?
  end

  def first_error
    errors.first
  end

  def add_error(error)
    @errors ||= []

    return if error.nil?

    if error.is_a?(BaseError)
      error.set_backtrace(caller) if error.backtrace.nil?
      errors << error
    elsif error.is_a?(Array)
      error.each { |e| add_error(e) }
    else
      err = BaseError.new(error)
      err.set_backtrace(caller)
      errors << err
    end
  end
end
