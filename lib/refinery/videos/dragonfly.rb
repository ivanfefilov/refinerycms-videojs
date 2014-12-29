require 'dragonfly'

module Refinery
  module Videos
    module Dragonfly

      class << self
        def configure!
          ActiveRecord::Base.extend ::Dragonfly::Model
          ActiveRecord::Base.extend ::Dragonfly::Model::Validations

          app_videos = ::Dragonfly.app(:refinery_videos)
          app_videos.configure do
            # datastore ::Dragonfly::DataStorage::MongoDataStore.new(:db => MongoMapper.database)
            datastore :file, {
              :root_path => Refinery::Videos.datastore_root_path
            }
            url_format Refinery::Videos.dragonfly_url_format
            secret Refinery::Videos.dragonfly_secret
          end

          if ::Refinery::Videos.s3_backend
            require 'dragonfly/s3_data_store'
            options = {
              bucket_name: Refinery::Videos.s3_bucket_name,
              access_key_id: Refinery::Videos.s3_access_key_id,
              secret_access_key: Refinery::Videos.s3_secret_access_key
            }
            # S3 Region otherwise defaults to 'us-east-1'
            options.update(region: Refinery::Videos.s3_region) if Refinery::Videos.s3_region
            app_videos.use_datastore :s3, options
          end
        end

        def attach!
          Rails.application.config.middleware.use ::Dragonfly::Middleware, :refinery_videos
        end
      end

    end
  end
end
