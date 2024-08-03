class CreateCompetencies < ActiveRecord::Migration[7.1]
  def change
    create_table :competencies do |t|
      t.string :name, null: false, limit: 100

      t.timestamps
    end
  end
end
