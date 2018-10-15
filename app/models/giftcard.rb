
class Giftcard < ActiveRecord::Base  
    mount_uploader :thumbnail, ImageUploader
    mount_uploader :preview_swedish, ImageUploader
    mount_uploader :preview_english, ImageUploader
end
