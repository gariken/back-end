class UsersCommands::FindOrCreate
  def initialize(phone_number)
    return { data: { error: 'Phone number is empty' } } if phone_number.nil? || phone_number.blank?
    @phone_number = Phony.normalize(phone_number.gsub(/[^0-9]/, "").gsub(/^8/, "7"))
  end

  def execute
    password = Random.new.rand(1111..9999)
    user = User.find_for_database_authentication(phone_number: @phone_number)
    if user
      user.update(password: password)
      PassSendingJob.perform_later(@phone_number, password)
      { data: { state: 'old' } }
    else
      user = User.new(phone_number: @phone_number, password: password)
      if user.save
        PassSendingJob.perform_later(@phone_number, password)
        { data: { state: 'new' } }
      else
        { data: { error: user.errors } }
      end
    end
  end

end
