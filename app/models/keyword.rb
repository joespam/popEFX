class Keyword < ActiveRecord::Base
	# make searchable
	#
	searchkick autocomplete: ['word']

	has_many :pictures
end
