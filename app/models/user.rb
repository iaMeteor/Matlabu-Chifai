require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :last_name, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 5..80, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..80
  validates_uniqueness_of   :login, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :password, :password_confirmation, :first_name, :last_name, :encryptedKey, :email, :is_admin

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    if u && u.authenticated?(password)
      return u
    end
    nil
  end

  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
	
  private
  def encrypt(password)
    Digest::SHA1.hexdigest("#{password}")
  end



  end
# 

# 
# 
# validate :password_non_blank
#   
# 
#   
#   def self.authenticate(login, password)
#     user = self.find_by_login(login)
#     if user
#       expected_password = encrypted_password(password, user.salt)
#       if user.hashed_password != expected_password
#         user = nil
#       end
#     end
#     user
#   end
#   
#   
#   # 'password' is a virtual attribute
#   
#   def password
#     @password
#   end
#   
#   def password=(pwd)
#     @password = pwd
#     return if pwd.blank?
#     create_new_salt
#     self.hashed_password = User.encrypted_password(self.password, self.salt)
#   end
#   
#    def set_admin
#        return if self.is_admin == 1
#        self.is_admin = 0
#      end
# 
# 
# private
# 
#   def password_non_blank
#     errors.add(:password, "Missing password") if hashed_password.blank?
#   end
# 
#   
#   
#   def create_new_salt
#     self.salt = self.object_id.to_s + rand.to_s
#   end
#   
#   
#   
#   def self.encrypted_password(password, salt)
#     string_to_hash = password + "wibble" + salt
#     Digest::SHA1.hexdigest(string_to_hash)
#   end
#   
# 
# end