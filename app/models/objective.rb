class Objective < ApplicationRecord
    has_many    :objective_students, dependent: :destroy
    has_many    :objective_seminars, dependent: :destroy
    has_many    :seminars, through: :objective_seminars
    has_many    :preconditions, class_name: "Precondition",
                                foreign_key: "mainassign_id",
                                dependent: :destroy
    has_many    :mainconditions, class_name: "Precondition",
                                foreign_key: "preassign_id",
                                dependent: :destroy
    has_many    :preassigns, through: :preconditions, as: :mainassign, source: :preassign
    has_many    :mainassigns, through: :mainconditions, as: :preassign, source: :mainassign
    has_many    :label_objectives, dependent: :destroy
    has_many    :labels, through: :label_objectives
    has_many    :questions, through: :labels
    has_many    :teams, dependent: :destroy
    
    belongs_to  :user
    
    attribute   :extent, :string, default: "private"
    
    validates :name, presence: true, length: { maximum: 40 }
    
    include ModelMethods
    
    def full_name
        name[0,30] 
    end
    
    def priority_in(seminar)
        self.objective_seminars.find_by(:seminar => seminar).priority
    end
    
    def students_who_requested(seminar)
        seminar.seminar_students.where(:learn_request => self.id).count
    end
    
    def students_in_need(seminar)
        studsInNeed = 0
        seminar.students.each do |student|
            boog = student.objective_students.find_by(objective_id: id)
            if boog and boog.points and boog.points < 7 and student.check_if_ready(self)
                studsInNeed += 1
            end
        end
        return studsInNeed
    end
    

    
    
        

end
