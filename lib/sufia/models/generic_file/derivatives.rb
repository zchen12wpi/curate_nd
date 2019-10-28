module Sufia
  module GenericFile
    module Derivatives
      extend ActiveSupport::Concern
      include Hydra::Derivatives

      included do
        makes_derivatives do |obj|
          case obj.mime_type
            when *pdf_mime_types
              obj.transform_datastream :content,
                                       { :thumbnail => {size: "338x493", datastream: 'thumbnail'} }
            when *image_mime_types
              obj.transform_datastream :content, { :thumbnail => {size: "248x272", datastream: 'thumbnail'} }
          end
        end
      end

    end
  end
end
