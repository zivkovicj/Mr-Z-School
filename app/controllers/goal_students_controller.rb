class GoalStudentsController < ApplicationController
    
    def index
       @seminar = Seminar.find(params[:seminar])
       goals_stuff
    end
    
    def print
       @seminar = Seminar.find(params[:seminar]) 
       goals_stuff
    end
    
    def edit
        @goal_student = GoalStudent.find(params[:id])
    end
    
    def update
        @gs = GoalStudent.find(params[:id])
        if @gs.update_attributes(goal_student_params)
            @gs.gs_update_stuff
            flash[:success] = "Profile updated"
            redirect_to checkpoints_goal_student_path(@gs)
        else
            redirect_to student_view_seminar_path(@gs.seminar, :user => @gs.user.id)
        end
    end
    
    def checkpoints
       @gs = GoalStudent.find(params[:id])
       @seminar = @gs.seminar
    end
    
    def update_checkpoints
        @gs = GoalStudent.find(params[:id])
        if params[:syl]
            params[:syl].each do |key, value|
                @checkpoint = Checkpoint.find(key)
                @checkpoint.update(:action => value[:action])
            end
        end
        redirect_to student_view_seminar_path(@gs.seminar, :user => @gs.user.id)
    end
    
    private
    
        def goal_student_params
            params.require(:goal_student).permit(:goal_id, :target, :approved)
        end
        
        def goals_stuff
            @seminar.update(:which_checkpoint => params[:which_checkpoint]) if params[:which_checkpoint]
            @seminar.update(:term => params[:term]) if params[:term]
            @this_term = @seminar.term
            @this_checkpoint = @seminar.which_checkpoint
        end
end