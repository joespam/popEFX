class Picture < ActiveRecord::Base
  # make searchable
  #
  searchkick word_start: [:title,:description]

  # exclude rating from searches until I figure out
  # how to avoid the mapper_parsing/number_format_exception
  def search_data
    attributes.except(:rating)
  end

  acts_as_votable

  belongs_to :user


  has_attached_file :originalImage,
    default_url: "/images/:style/missing.png",
    storage: :filesystem,
    path: ":rails_root/clientAssets/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :originalImage, content_type: /\Aimage\/.*\z/

  # has_attached_file :image, styles: { medium: "300x300>", small: "150x150>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_attached_file :image,
    styles: { medium: "300x300>", small: "150x150>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png",
    storage: :filesystem,
    path: "/system/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_attached_file :publicImage,
    styles: { medium: "300x300>", small: "150x150>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png",
    storage: :filesystem,
    path: "/system/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :publicImage, content_type: /\Aimage\/.*\z/



  has_many :keywords

  # additional attr for keywords, which are a separate table
  #
  attr_accessor :keywords

  ####################
  # public methods

  def getImageUrl
    url = self.image.url
  end
  def readImageFile
    img = Magick::Image.read(self.image.path).first
  end

  def getPublicImageUrl
    url = self.publicImage.url
  end
  def getPublicImageFile
    img = Magick::Image.read(self.publicImage.path).first
  end

  def getOriginalImageFile
    img = Magick::Image.read(self.originalImage.path).first
  end

  def watermarkImage(original_file, watermark_file)
    #
    # put code to resize the watermark file to match the original file here
    #
    # make a new watermarked image using the composite method
    img = original_file.composite(watermark_file, Magick::CenterGravity, Magick::SoftLightCompositeOp)
  end

end
