require 'bcrypt'

class People < Sequel::Model(:people)
  attr_accessor :password, :password_confirmation

  many_to_many :groups, :left_key=>:people_id, :right_key=>:group_id, :join_table=>:group_admins, :class=>"Group"

  def password=(password)
    @password = password

    return if password.nil? || password.empty?
    self.crypted_password = BCrypt::Password.create(password)
  end

  def before_validation
    @email = @email.to_s.downcase
    super
  end

  plugin :validation_helpers
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i unless defined? EMAIL_REGEX

  def validate
    super

    # require a value for auth0_id address
    #validates_presence  :auth0_id

    # make sure the auth0_id address is unique
    validates_unique    :auth0_id
  end

  def self.auth(session)
    people = first(email: session[:email].downcase)

    if people && people.auth?(session.password)
      return people
    else
      return nil
    end
  end

  def auth?(password)
    BCrypt::Password.new(crypted_password) == password
  end
  def self.authenticate(session)
    log_debug(session)
    u = People.where(:email => session.login).first#<-- "session.login.downcase" ensures email part of login input is lowercase when submitted

    if u && u.authenticated?(session.password)
      return u
    else
      return false
    end
  end
  def authenticated?(auth_password)
    return password == auth_password
  end
  def is_admin?()
    return :admin
  end

  def category_one_id
    unless categories.nil?
      JSON.parse(categories.to_json)[0]
    end
  end

  def category_two_id
    unless categories.nil?
      JSON.parse(categories.to_json)[1]
    end
  end

  def category_three_id
    unless categories.nil?
      JSON.parse(categories.to_json)[2]
    end
  end
end
