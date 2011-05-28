class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :token_authenticatable, :confirmable, :lockable, :timeoutable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  def inactive_message
    #if !approved?
    #  :not_approved
    #else
      super
    #end
  end

  def active_for_authentication?
    #super && approved?
    super
  end

  def valid_for_authentication?
    if confirmed?
      block_given? ? yield : true
    else
      inactive_message
    end
  end

end
