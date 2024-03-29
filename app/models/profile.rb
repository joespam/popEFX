class Profile < ActiveRecord::Base
	# make searchable
	#
	searchkick word_start: [:brandname]

	acts_as_votable

	has_one :user

	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

	has_attached_file :heroImage, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :heroImage, content_type: /\Aimage\/.*\z/

end
