# frozen_string_literal: true

class UploadFileClientStreamHandler < BaseHandler
  IMAGE_EXTENSIONS = %w[.jpg .jpeg .png .gif].freeze

  def initialize(call)
    # rubocop:disable Lint/MissingSuper
    @call = call
  end

  def call
    Rails.logger.info "Uploading file: #{filename}"

    read_chunk

    service = CreateFileService.call(temp_file, filename, mime_type)

    raise service.first_error if service.error?

    data = service.data
    url = GenerateUrlService.call(
      data.file,
      {
        download: true
      }
    ).data

    Files::UploadFileResponse.new(**
                                  {
                                    id: data.id,
                                    name: filename,
                                    type: mime_type
                                  }.merge(url)
    )
  ensure
    # https://ruby-doc.org/stdlib-3.1.1/libdoc/tempfile/rdoc/Tempfile.html#class-Tempfile-label-Explicit+close
    temp_file.close
    temp_file.unlink
  end

  def temp_file
    @temp_file ||= Tempfile.new(binmode: true)
  end

  def read_chunk
    @call.each_remote_read do |upload_request|
      Rails.logger.info "Received chunk of size: #{upload_request.content.bytesize}"
      temp_file.write(upload_request.content)
    end
  end

  def mime_type
    @mime_type ||= Marcel::MimeType.for(temp_file, name: filename)
  end

  def metadata
    @call.metadata
  end

  def filename
    metadata['filename']
  end
end
