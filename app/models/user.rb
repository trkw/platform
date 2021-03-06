class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # attr_accessible :email, :password, :password_confirmation, :logo, :logo_cache, 
  #                 :name, :occupation, :vat, :address_street, :address_country, :address_city, 
  #                 :address_zip, :phone_number, :fax_number, :link, :user_type, :buyer_type

  # attr_protected [nil]
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :async,
         :omniauthable, :omniauth_providers => [:facebook, :linkedin]

         
  mount_uploader :logo, LogoUploader
   
  scope :buyers, -> { where(user_type: :buyer) }
  scope :sellers, -> { where(user_type: :seller) }

  scope :premium, -> { where(seller_type: :premium) }
  scope :free,    -> { where(seller_type: :free) }
  
  paginates_per 2
  
  has_many :products # as a seller
  has_many :auctions,foreign_key: :seller_id # as a seller
  has_many :biddings # as a buyer
  has_many :billings
  has_many :orders
  has_many :notifications
  
  has_one  :seller

  accepts_nested_attributes_for :billings, :allow_destroy => true
  
  after_create :build_seller_object
  
  
  
  
  
    
  
  def billing_info
    # The specs are now with single billing / user - this can change in the future though on this architecture.    
    self.billings.first  
  end


  def shipping_info
    case shipping_type 
      when "billing"
        self.billing_info.address_summary
      when "shipping"
        self.user_address_summary
      when "custom"
        self.shipping_custom_instructions
    end      
  end


  def user_address_summary
    return "#{self.address_street} #{self.address_city} #{self.address_zip} #{self.address_country}"
  end

  
  def relevant_products(excluded_product_id, limit)
    self.products.where("id <> ?", excluded_product_id).limit(limit)
  end


  def build_seller_object
    # Call this only when a Seller user is created and not in every case of new user!
    # It depends on the UI / How the form will look or if we will have separate forms for the 2 user types.
    Seller.create({:user_id => self.id})  
  end
  

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.logo = auth.info.image # assuming the user model has an image
    end
  end


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end


  def ratings_received
    return Rating.where(to_user_id: self.id)
  end
  

  def can_rate_the_user?(relative_user)
    # The rating system allows a user to rate another user only if they have some
    # succesfful exchange with eachother.
    # TODO  : Define the actions that define a successful relationship. 
    # Case 1: A buyer user (self) has at least on WINNER bidding at an Auction of the relative_user  
    return relative_user.auctions.where("winning_buyer_id = ?", self.id).where("status = ? OR status = ?", "finished", "bought").count > 0
  end

  def name_and_email
    return "#{name} (#{email})"
  end
    
  def is_buyer?
    return user_type == "buyer"
  end       
  
  def is_seller?
    return user_type == "seller"
  end
  
  def is_free_seller?
    return user_type == "buyer" && seller_type == "free"
  end

  def is_premium_seller?
    return user_type == "buyer" && seller_type == "premium"
  end

  def products_bought
    won_auction_ids = self.orders.collect(&:auction_id)
    won_product_ids = Auction.where(id: won_auction_ids).collect(&:product_id)
    Product.where(id: won_product_ids)
  end


  # OVERRRIDING DEVISE FOR PASSWORD CONFIRMATION MISSING AND REQUIRED
  def password_required?
    false
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    return true unless password.blank?
  end

  
end
