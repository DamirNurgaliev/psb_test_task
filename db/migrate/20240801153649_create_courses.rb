class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title, limit: 100, null: false
      t.text :description
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
