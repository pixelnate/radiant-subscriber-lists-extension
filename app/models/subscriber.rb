class Subscriber < ActiveRecord::Base
  validates_presence_of :email
  # validates_uniqueness_of :email, :message => "has already been signed up."
  validates_presence_of :subscriber_list_id

  #TODO: add validation to subscriber_list. Does the subscriber_list page exists?
  
  validates_format_of :email, :with => /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => Proc.new{|ns| !ns.email.blank? }
  
  class << self    
    def find_active_subscriber_by_subscriber_list_and_email(subscriber_list, email)
      find(:first, :conditions => ["unsubscribed_at IS ? AND subscriber_list_id = ? AND email = ?", nil, subscriber_list.id, email])
    end
    
    def find_active_subscribers
      find(:all, :conditions => {:unsubscribed_at => nil})
    end
    
    def find_inactive_subscribers
      find(:all, :conditions => {:unsubscribed_at => !nil})
    end
    
    def count_active_subscribers(subscriber_list)
      count(:conditions => {:unsubscribed_at => nil, :subscriber_list_id => subscriber_list.id })
    end
    
    def find_active_subscribers_by_subscriber_list(subscriber_list)
      find(:all, 
            :conditions => ["unsubscribed_at IS NULL AND subscriber_list_id = ?", subscriber_list.id],
            :order => "subscribed_at DESC")
    end
    
    def find_unsubscribers_by_subscriber_list(subscriber_list)
      find(:all, 
            :conditions => ["unsubscribed_at IS NOT NULL AND subscriber_list_id = ?", subscriber_list.id],
            :order => "unsubscribed_at DESC")
    end
  end
  
end