class QuizzesController < ApplicationController
    
    def new
        @objective = Objective.find(params[:objective_id])
        @quiz = Quiz.create(:objective => @objective, :student => current_user)
        quest_collect = []
        @objective.label_objectives.each do |lo|
            quant = lo.quantity
            label = lo.label
            label.questions.order("RANDOM()").limit(quant).each do |quest|
                quest_collect.push([quest.id, lo.point_value])
            end
            debugger
        end
        
        quest_collect.shuffle.each_with_index do |q_info, index|
            @quiz.ripostes.create(:question_id => q_info[0], :position => index+1, :poss => q_info[1]) 
        end
        
        redirect_to edit_riposte_path(@quiz.ripostes.first)
    
    end
    
    def show
        @quiz = Quiz.find(params[:id])
        
        student = current_user
        score = student.objective_students.find_by(:objective => @quiz.objective)
        @old_points = (score == nil ? 0 : score.points) 
    
        poss = 0
        stud_score = 0
        @quiz.ripostes.each do |riposte|
            poss += riposte.poss
            stud_score += (riposte.tally)
        end
        
        new_total = ((stud_score * 100)/poss).round
        @quiz.update(:total_score => new_total)
        
        if new_total > @old_points
            score.update(:points => new_total)
        end
        
        @total_score = @quiz.total_score
    end
    
end