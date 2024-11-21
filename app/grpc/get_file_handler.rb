# frozen_string_literal: true

class GetFileHandler < BaseHandler
  def call
    if file.blank?
      return Files::GetFileResponse.new(
        success: false,
        error_message: 'File not found'
      )
    end

    url = GenerateUrlService.call(
      file,
      {
        download: request.download_url,
        remote: request.remote_url,
      }).data

    Files::GetFileResponse.new(**
                               { success: true,
                                 name: file.filename.to_s,
                                 type: file.content_type,
                               }.merge(url)
    )
  end

  private

  def file
    @file ||= UploadedFile.find_by(id: request.id)&.file
  end
end
