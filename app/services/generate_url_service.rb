# frozen_string_literal: true

class GenerateUrlService < Base
  def initialize(file, option)
    super

    @file = file
    @option = option
  end

  def call
    @data = {}

    build_data(:remote_url, remote_kwargs) if remote?
    build_data(:download_url, download_kwargs) if download?

    self
  end

  private

  def download?
    @option[:download] == true
  end

  def remote?
    @option[:remote] == true
  end

  def remote_kwargs
    @remote_kwargs ||= { only_path: true }
  end

  def download_kwargs
    @download_kwargs ||= remote_kwargs.merge(disposition: "attachment")
  end

  def build_data(key, kwargs)
    @data[key] ||= Rails.application.routes.url_helpers.rails_blob_path(@file, **kwargs)
  end
end
