class CreateCourseCompetencies < ActiveRecord::Migration[7.1]
  def change
    create_table :course_competencies do |t|
      t.references :course, null: false, foreign_key: true
      t.references :competency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
