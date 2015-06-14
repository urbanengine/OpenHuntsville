class Token < Sequel::Model
  plugin :validation_helpers

  many_to_one :user

  def validate
    super
    validates_presence [:code, :expires_at], :message => "must not be blank"
    validates_format /^(?:authentication|password_reset)$/, :type, message: "is not a valid type"
  end

  def after_create
    # if creating a valid token, invalidate any other tokens of this type that belong to this user
    token = Token[self.id]
    Token.where(:user => token.user, :type => token.type, :valid => true).exclude(:id => token.id).update(:valid => false) if token.valid
    super
  end

  def self.find_valid(code)
    where('expires_at >= ?', DateTime.now).first(:code => code, :valid => true)
  end
  
  def use!
    update(valid: false, used_at: DateTime.now)
  end
end
