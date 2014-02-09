class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.integer :user_id
      t.string  :status

      t.text    :message

      t.timestamps
    end
  end
end
