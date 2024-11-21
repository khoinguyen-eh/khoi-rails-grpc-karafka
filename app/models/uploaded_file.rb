# frozen_string_literal: true

class UploadedFile < ApplicationRecord
  has_one_attached :file, dependent: :purge
end
