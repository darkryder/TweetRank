class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :identifier
      t.text :data

      t.timestamps
    end
  end
end
