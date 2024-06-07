class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.belongs_to :votable, polymorphic: true
      t.boolean :voted, null: false

      t.timestamps
    end
  end
end
