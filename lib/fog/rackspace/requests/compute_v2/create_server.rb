module Fog
  module Compute
    class RackspaceV2
      class Real
        def create_server(name, image_id, flavor_id, min_count, max_count, options = {})
          data = {
            'server' => {
              'name' => name,
              'imageRef' => image_id,
              'flavorRef' => flavor_id,
              'minCount' => min_count,
              'maxCount' => max_count
            }
          }
          if options['metadata']
            data['server']['metadata'] = options['metadata']
          end
          if options['personality']
            data['server']['personality'] = []
            for file in options['personality']
              data['server']['personality'] << {
                'contents'  => Base64.encode64(file['contents']),
                'path'      => file['path']
              }
            end
          end

          # Even though docs say this should be diskConfig, need to pass OS-DCF:diskConfig
          data['server']["OS-DCF:diskConfig"] = options['disk_config'] unless options['disk_config'].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers"
          )
        end
      end
    end
  end
end
