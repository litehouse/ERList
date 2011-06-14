# == Schema Information
# Schema version: 20110602075433
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

# created the above comments with the annotation gem, use the "annotate" command to get the below inserted



class User < ActiveRecord::Base
    
    after_destroy :ensure_one_admin_remains
    
    attr_accessor :password
    attr_accessible :name, :email, :password, :password_confirmation, :admin
    
    has_many :votes, :foreign_key => "voter_id",
                        :dependent => :destroy
    
    has_many :votes_for, :through => :votes, :source => :voted    
    
    has_many :microposts, :dependent => :destroy
    
    has_many :books, :foreign_key => "creator_id",
                     :class_name => 'Book',
                     :dependent => :destroy
    
    has_many :relationships, :foreign_key => "follower_id",
                             :dependent => :destroy
    has_many :following, :through => :relationships, :source => :followed
    
    
    has_many :reverse_relationships, :foreign_key => "followed_id",
                                    :class_name => "Relationship",
                                    :dependent => :destroy
    has_many :followers, :through => :reverse_relationships, :source => :follower
    
    has_many :comments, :dependent => :destroy
    
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :name,    :presence => true,
                        :length => { :maximum => 50 }
    validates :email,   :presence   => true,
                        :format     => { :with => email_regex},
                        :uniqueness => { :case_sensitive => false }
    
    #automatically create the virtual attribute "password confirmation"
    validates :password,    :presence => true,
                            :confirmation => true,
                            :length => { :within => 6..40}
    
    before_save :encrypt_password
    
    #return true if the user's password matches the submitted password
    def has_password?(submitted_password)
        encrypted_password == encrypt(submitted_password)
    end
    
    def self.authenticate(email, submitted_password)
      user = find_by_email(email)
      return nil if user.nil?
      return user if user.has_password?(submitted_password)
    end

    def self.authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end

    def feed
        Micropost.from_users_followed_by(self)
    end

    def following?(followed)
        relationships.find_by_followed_id(followed)
    end

    def votes_for?(voted)
        votes.find_by_voted_id(voted)
    end

    def follow!(followed)
        relationships.create!(:followed_id => followed.id)
    end

    def unfollow!(followed)
        relationships.find_by_followed_id(followed).destroy
    end

    def vote!(voted)
        votes.create!(:voted_id => voted.id)
    end

    def unvote!(voted)
        votes.find_by_voted_id(voted).destroy
    end

    def ensure_one_admin_remains
        if admin_count.zero?
            raise "Can't delete the last admin"
        end
    end



    
    private
    
      def encrypt_password
          self.salt = make_salt if new_record?
          self.encrypted_password = encrypt(password)
      end
    
      def encrypt(string)
          secure_hash("#{salt}--#{string}")
      end
    
      def make_salt
          secure_hash("#{Time.now.utc}--#{password}")
      end
    
      def secure_hash(string)
          Digest::SHA2.hexdigest(string)
      end

      def admin_count
          admins = User.where("admin = ?", true)
          admins.count
      end
    
    
    
end
