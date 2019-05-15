class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.text :body, null: false
      t.references :commentable, polymorphic: true, index: true

      t.timestamps
    end

    add_index :comments, [:user_id, :commentable_type]
  end
end
