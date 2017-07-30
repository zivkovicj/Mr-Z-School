class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save   :downcase_stuff
    before_create :create_activation_digest
    before_destroy  :destroy_associated_records
    
    #foreign_key: "teacher_id"
    
    has_many    :own_seminars, :class_name => "Seminar", foreign_key: 'teacher_id'
    has_many    :students, through: :own_seminars
    has_many    :objectives
    has_many    :questions
    has_many    :labels

                        
    
    validates :first_name, length: {maximum: 25},
            presence: true
    validates :last_name, length: {maximum: 25},
            presence: true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    
    has_secure_password
    
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true
    
    include ModelMethods
    
    class << self
        # Returns the hash digest of the given string.
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                          BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end
        
        # Returns a random token
        def new_token
            SecureRandom.urlsafe_base64
        end
    end
        
    # Remembers a user in the database for use in persistent sessions
    def remember 
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Forgets a user.
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    # Activates an account
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end
        
    # Sends activation email
    def send_activation_email
        #UserMailer.account_activation(self).deliver_now
    end
    
    # Sets the password reset attributes
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    # Sends password reset email
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    # Returns true if a password reset has expired
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    
    # Determines whether a teacher has an objective
    def has_objective?(this_objective)
       seminars.each do |seminar|
           return true if seminar.objectives.include?(this_objective)
       end
       return false
    end
    
    def nameWithTitle
        if title
            "#{title.split.map(&:capitalize).join(' ')} #{last_name.split.map(&:capitalize).join(' ')}"
        else
            "#{last_name.split.map(&:capitalize).join(' ')}"
        end
    end
 
    
    private

        # Converts info to all lower-case.
        def downcase_stuff
          self.email.downcase!
          self.first_name.downcase!
          self.last_name.downcase!
        end
    
        # Creates and assigns the activation token and digest.
        def create_activation_digest
          self.activation_token  = User.new_token
          self.activation_digest = User.digest(activation_token)
        end
        
        def destroy_associated_records
            Objective.where(:user => self).each do |objective|
                objective.destroy
            end
            self.own_seminars.each do |seminar|
                seminar.destroy
            end
        end
    
        
end
