class CreateStudentTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :student_teams, id:false do |t|
      t.references   :user, foreign_key: true
      t.references   :team, foreign_key: true
      t.timestamps
    end
    
    add_index  :student_teams, [:user_id, :team_id]
  end
end
