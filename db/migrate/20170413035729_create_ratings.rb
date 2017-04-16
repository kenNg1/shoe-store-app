class CreateRatings < ActiveRecord::Migration
    def change
    create_table(:ratings) do |t|
      t.column(:name, :string)
      t.column(:score, :int)
      t.column(:brand_id, :int)
      t.timestamps()
    end
  end
end
