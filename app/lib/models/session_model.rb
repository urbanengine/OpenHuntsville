class Session
  attr_accessor :email, :password

  def initialize(params)
    @email, @password = params.values_at(:email, :password)
  end

  def [](key)
    send(key) if respond_to?(key)
  end
end