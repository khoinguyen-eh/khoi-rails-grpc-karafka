# frozen_string_literal: true

class CreateFileService < Base
  def initialize(temp_file, filename, mime_type)
    super

    @temp_file = temp_file
    @filename = filename
    @mime_type = mime_type
  end

  def call
    uploaded_file = UploadedFile.create!
    uploaded_file.file.attach(
      io: temp_file,
      filename: filename,
      content_type: mime_type
    )

    @data = uploaded_file

    self
  end

  private

  attr_reader :temp_file, :filename, :mime_type
end
