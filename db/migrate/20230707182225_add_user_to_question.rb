class AddUserToQuestion < ActiveRecord::Migration[6.1]
  def change
    change_table :questions do |t|
      t.belongs_to :user, null: false, foreign_key: true
    end
  end
end
