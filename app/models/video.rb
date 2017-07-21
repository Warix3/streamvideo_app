class Video < ApplicationRecord
  mount_uploader :profile, VideoUploader
end
