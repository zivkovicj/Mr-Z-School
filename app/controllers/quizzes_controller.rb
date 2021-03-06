class QuizzesController < ApplicationController
    
    def new
        @objective = Objective.find(params[:objective_id])
        @quiz_taker_id = current_user.id
        seminar_id = current_user.current_class
        if @objective.questions.count > 0
            @origin = params[:origin]
            old_stars = @objective.objective_students.find_by(:user_id => @quiz_taker_id).points_this_term || 0
            @quiz = Quiz.create(:objective => @objective, 
                :user_id => @quiz_taker_id,
                :progress => 1,
                :origin => @origin,
                :old_stars => old_stars,
                :seminar_id => seminar_id)
            take_a_key
            check_if_six
            build_the_quiz
            redirect_to edit_riposte_path(@quiz.ripostes.first)
        else
            flash[:danger] = "This quiz doesn't have any questions. Please alert your teacher that you cannot take this quiz until some questions are added."
            @ss = SeminarStudent.find_by(:user_id => @quiz_taker_id, :seminar_id => seminar_id)
            redirect_to seminar_student_path(@ss)
        end
    end
    
    def edit    # Called when a student clicks on an unfinished quiz
        @objective = Objective.find(params[:objective_id])     
        @quiz = Quiz.find_by(:user => current_user, :objective => @objective, :total_score => nil)
        current_position = @quiz.progress
        @riposte = @quiz.ripostes.find_by(:position => current_position) || @quiz.ripostes.first
        redirect_to edit_riposte_path(@riposte)
    end
    
    def show
        @quiz = Quiz.find(params[:id])
        @objective = @quiz.objective
        @student = @quiz.user
        @this_os = @objective.objective_students.find_by(:user => @student) 
        establish_offer_next_try
    end
    
    private
    
        def take_a_key
            this_os = ObjectiveStudent.find_by(:user_id => @quiz_taker_id, :objective_id => @objective.id)
            old_keys = this_os.read_attribute(:"#{@origin}_keys")
            new_keys = old_keys - 1
            this_os.update(:"#{@origin}_keys" => new_keys)
        end
        
        def check_if_six
            quizzes_with_same_objective = Quiz.where(:user_id => @quiz_taker_id, :objective => @objective).order(:created_at)
            if quizzes_with_same_objective.count > 5
               quizzes_with_same_objective.first.destroy
            end
        end
    
        def build_the_quiz
            quest_collect = []
            @objective.label_objectives.each do |lo|
                quant = lo.quantity
                label = lo.label
                label.questions.order("RANDOM()").limit(quant).each do |quest|
                    quest_collect.push([quest.id, lo.point_value])
                end
            end
            
            quest_collect.shuffle.each_with_index do |q_info, index|
                @quiz.ripostes.create(:question_id => q_info[0], :position => index+1, :poss => q_info[1]) 
            end
        end
    
        def establish_offer_next_try
            if @this_os.dc_keys > 0
                @offer_next_try = "dc"
            elsif @this_os.teacher_granted_keys > 0
                @offer_next_try = "teacher_granted"
            elsif @this_os.pretest_keys > 0
                @offer_next_try = "pretest"
            else
                @offer_next_try = "none"
            end
        end
    
    
end