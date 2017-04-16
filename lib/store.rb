class Store < ActiveRecord::Base
  has_many :brands_stores, dependent: :destroy
  has_many :brands, through: :brands_stores

  validates(:name, {:presence => true})
  before_save(:upcase_name)

  private

  define_method(:upcase_name) do
    self.name=(name().upcase())
  end
end
