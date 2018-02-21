class RenameTableHabits < ActiveRecord::Migration[5.1]
  def change
    rename_table :habits, :patient_habits
    rename_table :morbids, :patient_morbids
    rename_table :physiologicals, :patient_physiologicals
    rename_table :courses, :student_courses
    rename_table :incidents, :student_incidents
  end
end
