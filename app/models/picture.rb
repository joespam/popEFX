class Picture < ActiveRecord::Base
	# make searchable
	#
	searchkick autocomplete: ['title','description']

	belongs_to :user

	has_attached_file :image, styles: { medium: "300x300>", small: "150x150>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	has_many :keywords

	# additional attr for keywords, which are a separate table
	#
	attr_accessor :keywords
end
