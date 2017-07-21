class CreateObjectives < ActiveRecord::Migration[5.0]
  def change
    create_table :objectives do |t|
      t.string  :name
      t.string  :extent
      t.integer :user_id, foreign_key: true
      
      t.timestamps
    end
  end
end
