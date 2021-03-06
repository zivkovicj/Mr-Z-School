# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Admin
Admin.create!(first_name:  "Jeff",
             last_name:   "Zivkovic",
             title: "Mr.",
             email: "zivkovic.jeff@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             user_number: 1,
             activated: true,
             activated_at: Time.zone.now)
             
jeff = Admin.first

Admin.create!(first_name:  "Second",
             last_name:   "InCommand",
             title: "Mr.",
             email: "noobsauce@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             user_number: 2,
             activated: true,
             activated_at: Time.zone.now)
 
Admin.create!(first_name:  "Business",
             last_name:   "Partner",
             title: "Mrs.",
             email: "businesspartner@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             user_number: 3,
             activated: true,
             activated_at: Time.zone.now)
             
Admin.create!(first_name:  "Last",
             last_name:   "Admin",
             title: "Ms.",
             email: "lastadmin@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             user_number: 4,
             activated: true,
             activated_at: Time.zone.now)

title_array = ["Mrs.", "Mr.", "Miss", "Ms.", "Dr."]

# Teachers
9.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  which_title = rand(title_array.length)
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  Teacher.create!(first_name:  first_name,
               last_name:   last_name,
               email: email,
               title: title_array[which_title],
               password:              password,
               password_confirmation: password,
               user_number: n,
               activated: true,
               activated_at: Time.zone.now)
end

# Seminars
sem_1 = Seminar.create!(name: "Main Teacher, 1st Period", user_id: 5, consultantThreshold: 7, term: 0, 
    which_checkpoint: 0, school_year: 9, :owner => Teacher.find(5))
sem_2 = Seminar.create!(name: "Main Teacher, 2nd Period", user_id: 5, consultantThreshold: 7, term: 0, 
    which_checkpoint: 0, school_year: 9, :owner => Teacher.find(5))
sem_3 = Seminar.create!(name: "Another Teacher, First Period", user_id: 6, consultantThreshold: 7, term: 0,
    which_checkpoint: 0, school_year: 9, :owner => Teacher.find(6))

sem_1.teachers << Teacher.find(5)
sem_2.teachers << Teacher.find(5)
sem_3.teachers << Teacher.find(6)
                
# objectives

assignNameArray = [[1,"Add and Subtract Numbers"],[1,"Multiply and Divide Numbers"],
    [1,"Numbers Summary"],
    [1,"Intercept"], [1,"Slope"], [1,"Scatterplots"], [1,"Association"],
    [1,"One-step Equations"], [2,"Integers"], [2,"Volume"], [2,"Fractions"], [2,"Rationals"], 
    [2,"Irrationals"], [3,"Volcanos"], [3,"Evolution"], [3,"Taxonomy"], [3,"Cells"], [3,"Anatomy"]]
    
assignNameArray.each_with_index do |objective, index|
    @objective = Objective.create(name: objective[1], :user => jeff, :extent => "public")
    ObjectiveSeminar.create(:seminar_id => objective[0], :objective => @objective, :priority => 2, :pretest => 0)
end


# Students       
29.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  email = "example-#{n+20}@railstutorial.org"
  password = "password"
  @student = Student.create!(first_name:  first_name,
               last_name:   last_name,
               email: email,
               user_number: n,
               password: password,
               school_year: 9)
   SeminarStudent.create!(seminar_id: 1, user_id: @student.id)
end

# Some students are registered to two class periods
SeminarStudent.create!(seminar_id: 2, user_id: 17)
SeminarStudent.create!(seminar_id: 2, user_id: 18)

18.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  email = "example-#{n+50}@railstutorial.org"
  password = "password"
  @student = Student.create!(first_name:  first_name,
               last_name:   last_name,
               email: email,
               user_number: n,
               password: password,
               school_year: 9)
   SeminarStudent.create!(seminar_id: 2, user_id: @student.id)
end

36.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  email = "example-#{n+100}@railstutorial.org"
  password = "password"
  @student = Student.create!(first_name:  first_name,
               last_name:   last_name,
               email: email,
               user_number: n,
               password: password,
               school_year: 9)
   SeminarStudent.create!(seminar_id: 3, user_id: @student.id)
end

Student.all.each do |student|
    student.update(:user_number => student.id)
    student.update(:username => "#{student.first_name[0,1].downcase}#{student.last_name[0,1].downcase}#{student.id}")
    student.update(:password => "#{student.id}")
end

# Scores
skillMatrix = [[0,0,0,0,5,7],[0,0,5,5,7,10],[0,5,7,10,10,10]]
Student.all.each do |student|
    skill = rand(3)
    student.seminar_students.each do |ss|
        seminar = ss.seminar
        seminar.objectives.each do |obj|
            scooby = rand(6)
            doo = skillMatrix[skill][scooby]
            ss.update(pref_request: skill)
            student.objective_students.create!(objective: obj, points: doo) if student.objective_students.find_by(:objective => obj) == nil
        end
    end
end

Label.create(:name => "Label for Pictures", :extent => "public", :user => jeff)
Label.create(:name => "Other Label for Pictures", :extent => "public", :user => jeff)

add_label = Label.create(:name => "Adding Numbers", :extent => "public", :user => jeff)
subtract_label = Label.create(:name => "Subtracting Numbers", :extent => "public", :user => jeff)
multiply_label = Label.create(:name => "Multiplying Numbers", :extent => "public", :user => jeff)
divide_label = Label.create(:name => "Dividing Numbers", :extent => "public", :user => jeff)

teacher_user = Teacher.first
Label.create(:name => "Intercept from Graphs", :extent => "public", :user => teacher_user)
Label.create(:name => "Intercept from Equations", :extent => "public", :user => teacher_user)
Label.create(:name => "Intercept from Tables", :extent => "public", :user => teacher_user)

add_and_sub_obj = Objective.find_by(:name => "Add and Subtract Numbers")
mult_and_div_obj = Objective.find_by(:name => "Multiply and Divide Numbers")
sum_obj = Objective.find_by(:name => "Numbers Summary")

LabelObjective.create(:label => add_label, :objective => add_and_sub_obj,
    :quantity => 2, :point_value => 2)
LabelObjective.create(:label => subtract_label, :objective => add_and_sub_obj,
    :quantity => 3, :point_value => 1)
    
LabelObjective.create(:label => multiply_label, :objective => mult_and_div_obj,
    :quantity => 3, :point_value => 2)
LabelObjective.create(:label => divide_label, :objective => mult_and_div_obj,
    :quantity => 2, :point_value => 2)
    
LabelObjective.create(:label => add_label, :objective => sum_obj,
    :quantity => 2, :point_value => 1)
LabelObjective.create(:label => subtract_label, :objective => sum_obj,
    :quantity => 1, :point_value => 2)
LabelObjective.create(:label => multiply_label, :objective => sum_obj,
    :quantity => 2, :point_value => 3)
LabelObjective.create(:label => divide_label, :objective => sum_obj,
    :quantity => 1, :point_value => 4)

pic_array = [["Labels", "app/assets/images/labels.png"],
    ["Objectives", "app/assets/images/objectives.png"],
    ["Desk Consultants", "app/assets/images/desk_consult.png"],]

pic_array.each do |n|
    pic = Picture.new(:name => n[0], :user => User.first)
    image_src = File.join(Rails.root, n[1])
    src_file = File.new(image_src)
    pic.image = src_file
    pic.save
end

Label.first.pictures << Picture.first
Label.first.pictures << Picture.second
Label.second.pictures << Picture.third

(1..10).each do |n|
    question = Question.new(:user => jeff, :extent => "public", :style => "multiple-choice")
    r = rand(10 * n)
    s = rand(6 * n)
    prompt_string = "What is #{r} + #{s} ?"
    question.prompt = prompt_string
    question.choice_0 = r + s
    question.choice_1 = r + s + 1
    question.choice_2 = r + s - 1
    question.choice_3 = r - s
    question.correct_answers = ["#{r + s}"]
    question.label = add_label
    question.save
    
    question = Question.new(:user => jeff, :extent => "public", :style => "multiple-choice")    
    r = rand(9 * n)
    s = rand(5 * n)
    prompt_string = "What is #{r} - #{s} ?"
    question.prompt = prompt_string
    question.choice_0 = r - s
    question.choice_1 = r + 1 - s
    question.choice_2 = (r - 1) - s 
    question.choice_3 = r + s
    question.correct_answers = ["#{r - s}"]
    question.label = subtract_label
    question.save
    
    question = Question.new(:user => jeff, :extent => "public", :style => "multiple-choice")
    r = rand(12)
    prompt_string = "What is #{n} x #{r} ?"
    question.prompt = prompt_string
    question.choice_0 = n * r
    question.choice_1 = n * (r + 1)
    question.choice_2 = n * (r - 1) 
    question.choice_3 = n * r
    question.choice_4 = (n - 1) * r
    question.correct_answers = ["#{(n) * r}"]
    question.label = multiply_label
    question.save
    
    question = Question.new(:user => jeff, :extent => "public", :style => "multiple-choice")
    r = rand(12)
    prompt_string = "What is #{n * r} / #{n} ?"
    question.prompt = prompt_string
    question.choice_0 = r
    question.choice_1 = r + 1
    question.choice_2 = r - 1
    question.choice_3 = r - 2
    question.choice_4 = 2 * r
    question.correct_answers = ["#{r}"]
    question.label = divide_label
    question.save
    
    question = Question.new(:user => jeff, :extent => "public", :style => "fill-in")
    r = rand(10 * n)
    s = rand(6 * n)
    prompt_string = "What is #{r} + #{s} ?"
    question.prompt = prompt_string
    question.correct_answers = ["#{r + s}"]
    question.label = add_label
    question.save
end

Precondition.create(:preassign => Objective.first, :mainassign => Objective.second)

c1 = Seminar.first.consultancies.create()
t1 = c1.teams.create(:consultant => Student.all[0])
t1.users << Student.all[1]
t1.users << Student.all[2]
t1.users << Student.all[3]
t2 = c1.teams.create(:consultant => Student.all[4])
t2.users << Student.all[5]
t2.users << Student.all[6]
t2.users << Student.all[7]

school_array = 
    [["Beaver High School", "Beaver", "UT"],
    ["Milford High School", "Milford", "UT"],
    ["Bear River High School", "Garland", "UT"],
    ["Box Elder High School", "Brigham", "UT"],
    ["Beaver High School", "Beaver", "UT"],
    ["Cache High School", "North Logan", "UT"],
    ["Mountain Crest High School", "Hyrum", "UT"],
    ["Sky View High School", "Smithfield", "UT"],
    ["Logan High School", "Logan", "UT"],
    ["East Carbon High School", "East Carbon", "UT"],
    ["Manila High School", "Manila", "UT"],
    ["Altamont High School", "Altamont", "UT"],
    ["Green River High School", "Green River", "UT"],
    ["East High School", "Salt Lake City", "UT"],
    ["West High School", "Salt Lake City", "UT"],
    ["Highland High School", "Salt Lake City", "UT"],
    ["Monticello High School", "Monticello", "UT"],
    ["Cedar Ridge High School", "Richfield", "UT"],
    ["North Summit High School", "Coalville", "UT"],
    ["Blue Peak High School", "Toole", "UT"],
    ["Wasatch High School", "Heber", "UT"],
    ["Carson High School", "Carson City", "NV"],
    ["Clark High School", "Las Vegas", "NV"]]
    
school_array.each do |school|
    School.create(:name => school[0], :city => school[1], :state => school[2], :market_name => "#{school[0]} Market", :school_currency_name => "#{school[0]} Bucks")
end

30.times do |n|
    item = School.first.commodities.new(:name => "Item #{n}", :current_price => n, :quantity => 3*n)
    item.image = Picture.all[rand(Picture.count)].image
    item.save
end

goal_array = [
    ["Turn in assignments",
      "I will turn in (?) % of my assignments this term.",
     [[0],
      ["Write all assignments in my planner.", "Check my grades online to see which assignments I'm missing.","Choose a classmate who is very good at completing assignments. Ask to be partners with that classmate."],
      ["Turn in (?) % of my assignments so far."],
      ["Write all assignments in my planner.", "Check my grades online to see which assignments I'm missing.","Choose a classmate who is very good at completing assignments. Ask to be partners with that classmate."],
      ["I will turn in (?) % of my assignments since Checkpoint 2."]]],
      
    ["Arrive to class on time",
       "I will arrive to class on time for (?) % of the school days this term.",
      [[0],
       ["Write a description of the reasons why I am sometimes tardy, and a short plan for how I will change my habits.", "Identify a friend who causes me to be tardy often."],
       ["Arrive to class on time for for (?) % of the school days so far."],
       ["Write a description of the reasons why I am sometimes tardy, and a short plan for how I will change my habits.", "Identify a friend who causes me to be tardy often."],
       ["I will arrive to class on time for (?) % of the days since Checkpoint 2."]]]]

goal_array.each do |this_goal|
    Goal.create(:name => this_goal[0], :statement_stem => this_goal[1], :actions => this_goal[2], :user_id => User.first.id, :extent => "public")
end

Teacher.all[0..5].each do |teach|
    teach.update(:school => School.first)
end
Teacher.all[6..8].each do |teach|
    teach.update(:school => School.second)
end

Student.all.each do |stud|
    stud.update(:sponsor => stud.seminars.first.teachers.first)
    stud.update(:school => stud.sponsor.school)
    stud.seminars.each do |seminar|
        4.times do |n|
            stud.goal_students.create(:seminar => seminar, :term => n)
        end
    end
end


