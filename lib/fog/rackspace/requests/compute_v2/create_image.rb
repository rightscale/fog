module Fog
  module Compute
    class RackspaceV2
      class Real

        # Create an image from a running server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to create image from
        # * options<~Hash> - Name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * 'image'<~Hash>:
        #     * 'id'<~String> - Id of image
        #     * 'name'<~String> - Name of image
        #     * 'serverId'<~Integer> - Id of server
        def create_image(server_id, name, options = {})
          data = {
            'createImage' => {
              'name' => name
            }
          }
          data['createImage'].merge!(options)
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action"
          )
        end
      end

      class Mock
        def create_image(server_id, name, options = {})
          response = Excon::Response.new
          response.status = 202

          now = Time.now
          data = {
            'created'   => now,
            'id'        => Fog::Mock.random_numbers(6).to_i,
            'name'      => name,
            'serverId'  => server_id,
            'status'    => 'SAVING',
            'updated'   => now.to_s,
          }

          self.data[:last_modified][:images][data['id']] = now
          self.data[:images][data['id']] = data
          response.body = { 'image' => data.reject {|key, value| !['id', 'name', 'serverId', 'status', 'updated'].include?(key)} }
          response
        end
      end

    end
  end
end
