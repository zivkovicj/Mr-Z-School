require 'test_helper'

class NewQuizTest < ActionDispatch::IntegrationTest
    
    def setup
        setup_users
        setup_schools
        setup_seminars
        setup_labels
        setup_objectives
        setup_questions
        setup_scores
        setup_goals
        
        @test_obj_stud = @objective_10.objective_students.find_by(:user => @student_2)
        @test_obj_stud.update(:teacher_granted_keys => 2, :ready => true)
    end
    
    def begin_quiz
        click_on("Quizzes")
        find("#teacher_granted_#{@objective_10.id}").click
    end

    def answer_question_correctly
        this_id = current_path[/\d+/].to_i
        @riposte = Riposte.find(this_id)
        @question = @riposte.question
        correct_answer = @question.correct_answers.first
        choose("choice_bubble_#{correct_answer}")
    end
    
    def answer_question_incorrectly
        this_id = current_path[/\d+/].to_i
        @riposte = Riposte.find(this_id)
        @question = @riposte.question
        incorrect_answer = (@question.correct_answers.first.to_i) + 1
        choose("choice_bubble_#{incorrect_answer}")
    end
    
    def prepare_fill_in
        @fill_in_objective = Objective.find_by(:name => "Fill-in Questions Only")
        set_specific_score(@student_2, @fill_in_objective, 4)
        @fill_in_objective.objective_students.find_by(:user => @student_2).update(:teacher_granted_keys => 2)
    end
    
    test "setup quiz" do
        old_riposte_count = Riposte.count
        current_term = @seminar.term
        term_start_date = Date.strptime(@school.term_dates[current_term][0], "%m/%d/%Y")
        @student_2.quizzes.create(:objective => @objective_10, :origin => "teacher_granted", :total_score => 2, :updated_at => term_start_date + 2.days)
        old_quiz_count = Quiz.count
        
        go_to_first_period
        begin_quiz
        @new_quiz = Quiz.last
        assert_equal @new_quiz.user, @student_2
        assert_equal @new_quiz.objective, @objective_10
        assert_equal old_quiz_count + 1, Quiz.count
        assert @new_quiz.old_stars >= 2
        
        new_riposte_count = @new_quiz.ripostes.count
        assert new_riposte_count > 0
        assert_equal old_riposte_count + new_riposte_count, Riposte.count
    end
    
    test "blank mc" do
        go_to_first_period
        begin_quiz
        
        @quiz = Quiz.last
        @riposte = @quiz.ripostes[0]
        assert_equal 1, @quiz.progress
        
        click_on "Next Question"
        
        assert_text "Question: 2"
        
        @riposte.reload
        assert_equal 0, @riposte.tally
        assert_equal "blank", @riposte.stud_answer
    end
    
    test "blank fill in" do
        prepare_fill_in
    
        go_to_first_period
        
        click_on("Quizzes")
        find("#teacher_granted_#{@fill_in_objective.id}").click
        
        @quiz = Quiz.last
        @riposte = @quiz.ripostes[0]
        
        # Skip entering an answer
        click_on "Next Question"
        
        @riposte.reload
        assert_equal 0, @riposte.tally
        assert_equal "blank", @riposte.stud_answer
    end
    
    test "take multiple-choice quiz" do
        setup_consultancies
        go_to_first_period
        begin_quiz
        assert_no_text("Your Scores in All Objectives")
        @new_quiz = Quiz.last
        assert @new_quiz.ripostes.count > 0
        assert_nil @new_quiz.total_score
        @new_quiz.ripostes.each do |riposte|
            assert riposte.tally.blank?
            assert_nil riposte.tally
        end
        answer_quiz_randomly
        click_on("Back to Your Class Page")
        
        # Replace this with the new line that checks to see if a student is on her profile page
        #assert_text("Your Scores in All Objectives")
        @new_quiz.reload
        assert_not_nil @new_quiz.total_score
        @new_quiz.ripostes.each do |riposte|
            assert_not riposte.tally.blank?
            assert_not_nil riposte.tally
        end
        assert @student_2.quizzes.include?(@new_quiz)
    end
    
    test "take fill in quiz" do
        prepare_fill_in
        
        go_to_first_period
        
        click_on("Quizzes")
        find("#teacher_granted_#{@fill_in_objective.id}").click
        @quiz = Quiz.last
        fill_in "stud_answer", with: "Yes"
        click_on "Next Question"
        @quiz.reload
        assert_equal 2, @quiz.progress
        fill_in "stud_answer", with: "No"
        click_on "Next Question"
        fill_in "stud_answer", with: "yes"
        click_on "Next Question"
        fill_in "stud_answer", with: "yes!"
        click_on "Next Question"
        fill_in "stud_answer", with: "ofcourse"
        click_on "Next Question"
        fill_in "stud_answer", with: "ofco urse"
        click_on "Next Question"
        @quiz.reload
        assert_equal 7, @quiz.progress
        fill_in "stud_answer", with: "course of"
        click_on "Next Question"
        
        @new_quiz = Quiz.last
        assert_equal 6, @new_quiz.total_score
        assert @student_2.quizzes.include?(@new_quiz)
    end
    
    test "100 total score" do
        @test_obj_stud.update(:dc_keys => 2)
        setup_consultancies
        
        go_to_first_period
        begin_quiz
        
        10.times do
            answer_question_correctly
            click_on("Next Question")
        end
        
        @new_quiz = Quiz.last
        assert_equal 10, @new_quiz.total_score
        @test_obj_stud.reload
        assert_equal 0, @test_obj_stud.teacher_granted_keys
        assert_equal 0, @test_obj_stud.dc_keys
    end
    
    test "improving points" do
        @test_obj_stud.update(:points_all_time => 1, :points_this_term => 1, :teacher_granted_keys => 2)
        set_specific_score(@test_obj_stud.user, @test_obj_stud.objective, 1)
       
        # Set up old_stud_need_count
        # This is to check that students_needed is updated upon passing a quiz       
        this_obj_sem = ObjectiveSeminar.find_by(:seminar => @seminar, :objective => @objective_10)
        this_obj_sem.students_needed_refresh
        old_stud_need_count = this_obj_sem.students_needed
        assert old_stud_need_count > 0
        
        # First try on quiz student scores 3 stars. An improvement of 2 stars.
        go_to_first_period
        begin_quiz
        3.times do
            answer_question_correctly
            click_on("Next Question")
        end
        7.times do
            answer_question_incorrectly
            click_on("Next Question")
        end
        
        @test_obj_stud.reload
        assert_equal 3, @test_obj_stud.points_all_time
        assert_equal 3, @test_obj_stud.points_this_term
        assert_nil @test_obj_stud.pretest_score
        assert_equal old_stud_need_count, this_obj_sem.students_needed
        
        # Second try on quiz student scores 8 stars. An improvement of 5 stars.
        click_on("Try this quiz again")
        9.times do
            answer_question_correctly
            click_on("Next Question")
        end
        1.times do
            answer_question_incorrectly
            click_on("Next Question")
        end
        
        @test_obj_stud.reload
        assert_equal 9, @test_obj_stud.points_all_time
        assert_equal 9, @test_obj_stud.points_this_term
        assert_equal old_stud_need_count - 1, this_obj_sem.reload.students_needed
    end
    
    test "quizzed better last term" do
        Quiz.create(:user => @student_2, :objective => @objective_10, :origin => "teacher_granted", :total_score => 8)
        @test_obj_stud.update(:teacher_granted_keys => 2, :points_this_term => nil, :points_all_time => 8)
        
        go_to_first_period
        begin_quiz
        5.times do
            answer_question_correctly
            click_on("Next Question")
        end
        5.times do
            answer_question_incorrectly
            click_on("Next Question")
        end
        
        @test_obj_stud.reload
        assert_equal 8, @test_obj_stud.points_all_time
        assert_equal 5, @test_obj_stud.points_this_term
    end
    
    test "quizzed better this term" do
        set_specific_score(@student_2, @objective_10, 8)
        @test_obj_stud.update(:teacher_granted_keys => 2, :points_all_time => 8, :points_this_term => 8)
        @student_2.quizzes.create(:objective => @objective_10, :total_score => 8, :origin => "teacher_granted")
        
        go_to_first_period
        begin_quiz
        5.times do
            answer_question_correctly
            click_on("Next Question")
        end
        5.times do
            answer_question_incorrectly
            click_on("Next Question")
        end
        
        @test_obj_stud.reload
        assert_equal 8, @test_obj_stud.points_all_time
        assert_equal 8, @test_obj_stud.points_this_term
    end
    
    test "pretest" do
        @test_obj_stud.update(:teacher_granted_keys => 0, :pretest_keys => 2, :points_all_time => nil, :points_this_term => nil)
        @first_mainassign = @objective_10.mainassigns.first
        @mainassign_os = @student_2.objective_students.find_by(:objective => @first_mainassign)
        @mainassign_os.update(:teacher_granted_keys => 0, :pretest_keys => 2, :points_all_time => nil, :points_this_term => nil)
        
        go_to_first_period
        click_on("Quizzes")
        find("#pretest_#{@objective_10.id}").click
        
        # 1 times do
        answer_question_correctly
        click_on("Next Question")

        9.times do
            answer_question_incorrectly
            click_on("Next Question")
        end
        
        # Doesn't take the keys yet, because student still has another try
        @test_obj_stud.reload
        
        assert_equal 1, @test_obj_stud.pretest_keys
        assert_equal 1, @test_obj_stud.pretest_score
        assert_equal 1, @test_obj_stud.points_all_time
        assert_nil @test_obj_stud.points_this_term
        assert_equal 2, @mainassign_os.reload.pretest_keys  
        
        click_on("Try this quiz again")
        3.times do
            answer_question_correctly
            click_on("Next Question")
        end
        7.times do
            answer_question_incorrectly
            click_on("Next Question")
        end
        
        # Now it takes the pretest keys for the post-requisites to spare the student the struggle of taking a pre-test that she is doomed to fail.
        @test_obj_stud.reload
        assert_equal 0, @test_obj_stud.pretest_keys
        assert_equal 3, @test_obj_stud.pretest_score
        assert_equal 3, @test_obj_stud.points_all_time
        assert_nil      @test_obj_stud.points_this_term
        assert_equal 0, @mainassign_os.reload.pretest_keys   
    end
    
    test "set ready upon passing" do
        other_preassign = Objective.create(:name => "Other Preassign")
        mainassign_1 = Objective.create(:name => "Mainassign 1")
        mainassign_2 = Objective.create(:name => "Mainassign 2")
       
        mainassign_1.preassigns << @objective_10
        mainassign_2.preassigns << @objective_10
        mainassign_2.preassigns << other_preassign
        os_1 = ObjectiveStudent.create(:user => @student_2, :objective => mainassign_1, :ready => false)
        os_2 = ObjectiveStudent.create(:user => @student_2, :objective => mainassign_2, :ready => false)
        ObjectiveStudent.create(:user => @student_2, :objective => other_preassign, :points_all_time => 2)
        
        @test_obj_stud.update(:teacher_granted_keys => 2)
       
        go_to_first_period
        begin_quiz
        
        10.times do
            answer_question_correctly
            click_on("Next Question")
        end
        
        assert os_1.reload.ready
        assert_not os_2.reload.ready
    end
    
    
end