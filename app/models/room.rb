class Room < ActiveRecord::Base

    extend FriendlyId

	  # É necessário definir o has_many primeiro!
    has_many :reviews, :dependent => :destroy
    #junta todos os registros de avaliação que o usuário possui e, através desses registros, buscar os quartos.
    #has_many :reviewed_rooms, :through => :reviews, :source => :room #
    belongs_to :user

  	attr_accessible :description, :location, :title, :picture
  	validates_presence_of :title
    validates_presence_of :slug
    validates_length_of :description, :minimum => 30, :allow_blank => false
  
    mount_uploader :picture, PictureUploader
    friendly_id :title, use: [:slugged, :history]

  	def complete_name
		"#{title}, #{location}"
	 end

	 def self.most_recent
    order(created_at: :desc)
  end

  def self.search(query)
    if query.present?
      where(['location LIKE :query OR
      title LIKE :query OR
      description LIKE :query', :query => "%#{query}%"])
    else
      scoped
    end
  end

end
