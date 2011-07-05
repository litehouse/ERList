# == Schema Information
# Schema version: 20110608195226
#
# Table name: books
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  author     :string(255)
#  isbn       :string(255)
#  publisher  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  image_url  :string(255)
#  creator_id :integer
#

class Book < ActiveRecord::Base

    
    ISBN10_REGEX = /^(?:\d[\ |-]?){9}[\d|X]$/
    ISBN13_REGEX = /^(?:\d[\ |-]?){13}$/
    
    VALID_ISBNS = [ISBN10_REGEX,ISBN13_REGEX]
    
    attr_accessible :title, :author, :isbn, :publisher, :image_url, :creator_id
    
    validates :title,    :presence => true
    validates :author,   :presence   => true
    
    
   
    validates :isbn,     :format     => { 
                                :with =>  Regexp.new(VALID_ISBNS.join('|')),
                                :message => 'invalid, only ISBN10 and ISBN13 allowed'},
                                :uniqueness => true

    validates :image_url, :format => {
        :with   =>  %r{\.(gif|jpg|png)$}i,
        :message => 'must be a valid url for gif, jpg, or png image'
    }

    
    has_many :votes, :foreign_key => "voted_id",
                    :dependent => :destroy
    
    has_many :votes_from, :through => :votes, :source => :voter    
    
    has_many :comments, :foreign_key => "book_id",
                        :dependent => :destroy
    
    belongs_to :user, :class_name => 'User',
                      :foreign_key => 'creator_id'
    
    def book_feed
        comments
    end
    
    def self.per_page
    10
    end
    
end
