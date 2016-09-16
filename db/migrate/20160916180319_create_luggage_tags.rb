class CreateLuggageTags < ActiveRecord::Migration[5.0]
  def change
    create_table :luggage_tags do |t|
      t.integer :user_id
      t.string :uuid
      t.string :origin
      t.string :destination
      t.datetime :start
      t.datetime :end
      t.datetime :lost_at
      t.datetime :found_at
      t.datetime :ok_at

      t.timestamps
    end
  end
end
