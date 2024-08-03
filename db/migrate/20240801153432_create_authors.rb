class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :name, limit: "100", null: false, default: ""
      t.string :email, limit: "255", null: false, index: { unique: true }

      t.timestamps
    end
  end
end
