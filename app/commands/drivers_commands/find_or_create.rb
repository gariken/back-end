class DriversCommands::FindOrCreate
  def initialize(phone_number)
    return { data: { error: 'Phone number is empty' } } if phone_number.nil? || phone_number.blank?
    @phone_number = Phony.normalize(phone_number.gsub(/[^0-9]/, "").gsub(/^8/, "7"))
  end

  def execute
    password = Random.new.rand(1111..9999)
    driver = Driver.find_for_database_authentication(phone_number: @phone_number)
    if driver
      driver.update(password: password)
      PassSendingJob.perform_later(@phone_number, password)
      { data: { state: 'old' } }
    else
      driver = Driver.new(phone_number: @phone_number, password: password)
      driver.balance = 100
      driver.points = 0
      driver.rating = 0
      if driver.save
        PassSendingJob.perform_later(@phone_number, password)
        { data: { state: 'new' } }
      else
        { data: { error: driver.errors } }
      end
    end
  end

end
