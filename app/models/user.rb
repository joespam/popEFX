class User < ActiveRecord::Base

  # make searchable
  #
  searchkick word_start: [:user]

  acts_as_votable

  # exclude rating from searches until I figure out
  # how to avoid the mapper_parsing/number_format_exception
  def search_data
    attributes.except(:rating)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable

  has_many :pictures, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :following, dependent: :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  accepts_nested_attributes_for :profile, :allow_destroy => true

  validates :username,
    :presence => false,
    :uniqueness => {
      :case_sensitive => false
    }

  validate :validate_username

  # additional attrs for UI processing
  #
  attr_accessor :artist
  # at signup time, a user can upload up to 5 pictures
  # these will get added to the database at signup time
  #
  attr_accessor :pictures[5]
  serialize :pictures, Array

  attr_accessor :keywords[5]
  serialize :keywords, Array


  # currently adding an array of pictures is not working.
  # hardcoding five separate possible pictures instead.
  #
  attr_accessor :picture1
  attr_accessor :picture2
  attr_accessor :picture3
  attr_accessor :picture4
  attr_accessor :picture5

  # keywords automatically added at upload time
  #
  attr_accessor :keywordStr1
  attr_accessor :keywordStr2
  attr_accessor :keywordStr3
  attr_accessor :keywordStr4
  attr_accessor :keywordStr5

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # the use of 'lower' in mySQL may result in any index on the email column to be ignored.
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  protected

  def profile
    super || build_profile
  end

end
