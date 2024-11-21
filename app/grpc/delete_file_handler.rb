# frozen_string_literal: true

class DeleteFileHandler < BaseHandler
  def call
    if uploaded_file.blank?
      return Files::DeleteFileResponse.new(
        success: false,
        error_message: 'File not found'
      )
    end

    uploaded_file.destroy!

    Files::DeleteFileResponse.new(
      success: true
    )
  end

  private

  def uploaded_file
    @uploaded_file ||= UploadedFile.find_by(id: request.id)
  end
end
