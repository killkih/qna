# frozen_string_literal: true

class AddBestToAnswers < ActiveRecord::Migration[6.1]
  def change
    change_table :answers do |t|
      t.boolean :best, null: false, default: false
    end
  end
end
