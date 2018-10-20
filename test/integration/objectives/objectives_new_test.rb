require 'test_helper'

class ObjectivesFormTest < ActionDispatch::IntegrationTest
    
    def setup
        setup_users
        
        @old_objective_count = Objective.count
    end
    
    test "new objective button from main user page" do
        capybara_login(@teacher_1)
        assert_on_teacher_page
        click_on('Create a New Objective')
        assert_selector('h2', :text => 'New Objective', :visible => true)
        assert_not_on_teacher_page
    end
    
    
    test "empty name create" do
        capybara_login(@teacher_1)
        click_on('Create a New Objective')
        fill_in "name", with: ""
        click_on('Create a New Objective')
        
        @new_objective = Objective.last
        assert_equal "Objective #{@old_objective_count}", @new_objective.name
        assert_equal @old_objective_count + 1, Objective.count
    end
    
    test "user creates objective" do
        capybara_login(@teacher_1)
        click_on('Create a New Objective')
        
        name = "009 Compare Unit Rates"
        fill_in "name", with: name
        find("#public_objective").choose
        click_on('Create a New Objective')
        
        assert_text name
        
        @new_objective = Objective.last
        assert_equal @old_objective_count + 1, Objective.count
        assert_equal name, @new_objective.name
        assert_equal @teacher_1, @new_objective.user
        assert_equal "public", @new_objective.extent
    end
    
    test "admin creates objective" do
        capybara_login(@admin_user)
        click_on('Create a New Objective')

        name = "010 Destroy Unit Rates"
        fill_in "name", with: name
        click_on('Create a New Objective')
        
        @new_objective = Objective.last
        assert_equal @old_objective_count + 1, Objective.count
        assert_equal name, @new_objective.name
        assert_equal @admin_user, @new_objective.user
        assert_equal "private", @new_objective.extent
        assert_equal 0, @new_objective.objective_seminars.count
        assert_equal 0, @new_objective.labels.count
    end
    
end