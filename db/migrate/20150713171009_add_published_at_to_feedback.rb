class AddPublishedAtToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :published_at, :date
  end
end
