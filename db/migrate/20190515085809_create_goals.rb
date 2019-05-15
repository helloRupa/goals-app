class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.boolean :private, null: false, default: false
      t.boolean :completed, null: false, default: false
      t.string :title, null: false
      t.text :body, null: false
      t.integer :cheers, null: false, default: 0

      t.timestamps
    end

    add_index :goals, :user_id
  end
end
