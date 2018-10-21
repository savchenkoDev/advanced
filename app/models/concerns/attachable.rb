module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, as: :attachable, dependent: :destroy
    accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
  end

  def attachments_attributes
    attrs = []
    attachments.each do |attachment|
      attrs << { id: attachment.id, name: attachment.file.filename, url: attachment.file.url }
    end
    attrs
  end
end

