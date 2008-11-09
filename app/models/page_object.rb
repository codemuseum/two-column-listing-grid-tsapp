class PageObject < ActiveRecord::Base
  include ThriveSmartObjectMethods
  self.caching_default = 'interval[5]' #[in :forever, :page_update, :any_page_update, 'data_update[datetimes]', :never, 'interval[5]']
  
  serialize :left_listings, Array
  serialize :right_listings, Array
  
  attr_accessor :full_left_listings, :full_right_listings, :full_ungrouped_listings
  
  # Override caching information to be on data_update of the data path
  def caching
    @caching = "data_update[#{data_path}]"
  end

  def fetch_listings
    all_listings = organization.find_data(data_path, :include => [:name, :description, :url, :picture]).dup
    grab_right_listings all_listings
    grab_left_listings all_listings
    self.full_ungrouped_listings = all_listings
  end
  
  def after_initialize
    self.full_left_listings = []
    self.full_right_listings = []
  end
  
  
  
  def grab_right_listings(listing_data)
    self.full_right_listings = Array.new
    listing_data.each { |l| self.full_right_listings << l if self.right_listings.include?(l.urn) }
    listing_data.delete_if { |l| self.right_listings.include?(l.urn) }
  end
  def grab_left_listings(listing_data)
    self.full_left_listings = Array.new
    listing_data.each { |l| self.full_left_listings << l if self.left_listings.include?(l.urn) }
    listing_data.delete_if { |l| self.left_listings.include?(l.urn) }
  end
  
  
  def piped_left_listings=(str)
    self.left_listings = str.blank? ? [] : str.split('|')
  end
  
  def piped_left_listings
    self.left_listings ? self.left_listings.join('|') : ''
  end
  
  
  def piped_right_listings=(str)
    self.right_listings = str.blank? ? [] : str.split('|')
  end
  
  def piped_right_listings
    self.right_listings ? self.right_listings.join('|') : ''
  end
  
  alias_method :original_to_xml, :to_xml
  def to_xml(options = {})
    original_to_xml({:except => [:left_listings, :right_listings]}.merge(options))
  end
end
