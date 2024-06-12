class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.belongs_to :commentable, polymorphic: true
      t.string :body, null: false

      t.timestamps
    end
  end
end
