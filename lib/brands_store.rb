class BrandsStore < ActiveRecord::Base
  belongs_to :brand
  belongs_to :store
end
