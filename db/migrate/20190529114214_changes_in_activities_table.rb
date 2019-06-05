class ChangesInActivitiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :target_uuid, :string, after: :user_id
    add_column :activities, :category, :string, after: :target_uuid
    add_column :permissions, :topic, :string, after: :path

    add_index :activities, :target_uuid
    add_index :permissions, :topic
  end
end
