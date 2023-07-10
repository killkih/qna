# frozen_string_literal: true

class AddUsertoAnswers < ActiveRecord::Migration[6.1]
  def change
    change_table :answers do |t|
      t.belongs_to :user, null: false, foreign_key: true
    end
  end
end
