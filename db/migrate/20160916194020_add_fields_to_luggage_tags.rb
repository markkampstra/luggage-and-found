class AddFieldsToLuggageTags < ActiveRecord::Migration[5.0]
  def change
    add_column :luggage_tags, :found_by, :string
    add_column :luggage_tags, :found_comment, :text
  end
end
