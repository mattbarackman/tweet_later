class TweetsTable < ActiveRecord::Migration
   def change
    create_table :tweets do |t|
      t.string     :text
      t.references :user
      t.timestamps
    end
  end
end
