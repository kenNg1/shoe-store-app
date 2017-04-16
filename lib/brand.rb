class Brand < ActiveRecord::Base
  has_many :brands_stores
  has_many :stores, through: :brands_stores
  has_many :ratings

  validates(:name, {:presence => true})
  before_save(:upcase_name)

  private

  define_method(:upcase_name) do
    self.name=(name().upcase())
  end
end
