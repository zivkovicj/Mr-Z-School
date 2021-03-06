class Student < User
    
    has_many    :seminar_students, dependent: :destroy, foreign_key: :user_id
    has_many    :seminars, through: :seminar_students
    has_many    :commodity_students, dependent: :destroy, foreign_key: :user_id
    has_many    :objective_students, dependent: :destroy, foreign_key: :user_id
    has_many    :objectives, through: :objective_students
    has_many    :consulted_teams, :class_name => "Team", foreign_key: "consultant_id"
    belongs_to   :sponsor,  :class_name => "Teacher"
    
    validates_uniqueness_of :username, unless: Proc.new { |a| a.username.blank? }
    has_secure_password :validations => false, :allow_nil => true

    def bucks_current(category, target)
        self.bucks_earned(category, target) - self.bucks_spent(category, target)
    end
    
    def bucks_earned(category, target)
        self.currencies.where(category => target).sum(:value)
    end
    
    def bucks_spent(category, target)
        self.commodity_students.where(category => target).sum(:price_paid)
    end
    
    def com_quant(commode)
        self.commodity_students.where(:commodity => commode).sum(:quantity)
    end
    
    def com_quant_delivered(commode)
        self.commodity_students.where(:commodity => commode, :delivered => true).count 
    end
    
    def quiz_stars_this_term(seminar)
        objective_students
            .where(:objective => seminar.objectives).to_a
            .sum{ |x| x.points_this_term.to_i }
    end
    
    def stars_used_toward_grade_this_term(seminar, term)
        self.seminar_students.find_by(:seminar => seminar).stars_used_toward_grade[term]
    end
    
    def quiz_stars_all_time(seminar)
        objective_students.where(:objective => seminar.objectives).map(&:points_all_time).inject{|a,b| a.to_i + b.to_i}
    end
    
    # Returns first name with limit plus last initial
    def first_plus_init
        "#{first_name[0,15].split.map(&:capitalize).join(' ')} #{last_name[0,1].split.map(&:capitalize).join(' ')}" 
    end
    
    def full_name
        "#{first_name[0,20].split.map(&:capitalize).join(' ')} #{last_name[0,20].split.map(&:capitalize).join(' ')}"
    end
    
    def last_name_first
        "#{last_name[0,20].split.map(&:capitalize).join(' ')}, #{first_name[0,20].split.map(&:capitalize).join(' ')}"
    end
    
    def score_on(objective)
        objective_students.find_by(:objective => objective).points_all_time.to_i
    end
    
    def learn_request_in(seminar)
        self.seminar_students.find_by(:seminar => seminar).learn_request
    end
    
    def teach_request_in(seminar)
        self.seminar_students.find_by(:seminar => seminar).teach_request
    end
    
    def teach_options(seminar)
        objective_students
            .where(:objective => seminar.objs_above_zero_priority, :points_all_time => seminar.consultantThreshold..9)
            .select{|x| x.total_keys == 0}
            .sort_by {|x| -x.objective.priority_in(seminar)}
            .take(10)
            .map(&:objective)
    end
    
    def learn_options(seminar)
        c_thresh = seminar.consultantThreshold
        objective_students
            .where(:objective => seminar.objectives)
            .select{|x| x.total_keys == 0 && x.obj_ready_and_willing?(c_thresh)}
            .sort_by{|x| -x.objective.priority_in(seminar)}
            .take(10)
            .map(&:objective)
    end
    
    def present_in(seminar)
        self.seminar_students.find_by(:seminar => seminar).present
    end
    
    def advance_to_next_school_year
        self.update(:school_year => self.school_year + 1)
    end
    
    def student_has_keys(obj)
        objective_students.find_by(:objective => obj).total_keys
    end
end
