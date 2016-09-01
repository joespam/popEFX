class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	      :recoverable, :rememberable, :trackable, :validatable

	validates :username,
	  :presence => true,
	  :uniqueness => {
	    :case_sensitive => false
	  }

	validate :validate_username

	def validate_username
		if User.where(email: username).exists?
			errors.add(:username, :invalid)
			puts "--------------------------------------username is #{username}"
		end
	end

	def login=(login)
		@login = login
	end

	def login
		@login || self.username || self.email
	end

	def self.find_for_database_authentication(warden_conditions)
			puts "--------------------------------------wTF"

		conditions = warden_conditions.dup
		if login = conditions.delete(:login)
			# the use of 'lower' in mySQL may result in any index on the email column to be ignored.
			where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
		elsif conditions.has_key?(:username) || conditions.has_key?(:email)
		  where(conditions.to_hash).first
		end
	end

end
