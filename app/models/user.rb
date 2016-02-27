class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :first_name, type: String
  field :last_name, type: String
  field :transcript_number, type: String
  field :accounts_api_id, type: String
  field :username, type: String
  field :groups, type: Array, default: []
  field :start_year, type: String

  has_many :lists, foreign_key: 'owner_id'

  def self.find_for_accounts_api(data)
    @user = User.find_by(accounts_api_id: data['uid']) rescue nil
    params = {
      email: data['info']['email'],
      accounts_api_id: data['uid'],
      password: Devise.friendly_token.first(10),
      first_name: data['info']['first_name'],
      last_name: data['info']['last_name'],
      transcript_number: data['info']['transcript_number'],
      username: data['info']['username'],
      groups: data['info']['groups'],
      start_year: data['info']['start_year']
    }
    if @user
      @user.update!(params)
    else
      @user = User.create!(params)
    end
    @user
  end

  def groups_comma_separated
    groups.join(",")
  end

  def full_name
    "#{first_name} #{last_name} (#{username})"
  end

end
