module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_image(image_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "images/#{image_id}"
          )
        end
        alias :get_image_details :get_image
      end
    end
  end
end
