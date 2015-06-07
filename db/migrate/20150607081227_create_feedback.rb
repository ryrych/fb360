class CreateFeedback < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :content
      t.integer :giver_id
      t.integer :receiver_id
      t.string :feedback_type
      t.boolean :published, default: false
      t.timestamps
    end
    add_index :feedbacks, :giver_id
    add_index :feedbacks, :receiver_id
  end
end
