class ObjectiveSeminar < ApplicationRecord
    belongs_to :seminar
    belongs_to :objective
    
    attribute :priority, :integer, default: 2
    attribute :pretest, :integer, default: 0
    
    before_create :createScores
    
    def students_in_need
        objective.objective_students.where(:user => seminar.students).select{|x| !x.passed}.count
    end
    
    def addPreReqs
        objective.preassigns.each do |preassign|
            seminar.objective_seminars.find_or_create_by(:objective_id => preassign.id)
            seminar.students.each do |student|
                student.objective_students.find_or_create_by(:objective_id => preassign.id)
            end
        end
    end
    
    private
        def createScores
            seminar.students.each do |student|
                student.objective_students.find_or_create_by(:objective_id => objective.id)
            end
        end
        
        
end
