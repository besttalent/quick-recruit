module ImageAttachmentValidatable
  extend ActiveSupport::Concern

  class_methods do
    def validates_image_attachment(attribute, max_size: 1.megabyte, allowed_types: %w(image/jpeg image/png))
      validate do
        attachment = public_send(attribute)
        next unless attachment.attached?

        if attachment.blob.byte_size > max_size
          errors.add(attribute, "size should not be more than 1MB")
        end

        unless attachment.content_type.in?(allowed_types)
          errors.add(attribute, "must be a JPEG or PNG")
        end
      end
    end
  end
end