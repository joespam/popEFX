class Keyword < ActiveRecord::Base
	# make searchable
	#
	searchkick word_start: [:word]

	has_many :pictures
end
