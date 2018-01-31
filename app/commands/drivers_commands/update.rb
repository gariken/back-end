class DriversCommands::Update
  def initialize(driver, params)
    @driver = driver
    @params = params
  end

  def execute
    @driver.remove_license! unless @params[:license].nil?
    @driver.remove_photo! unless @params[:photo].nil?
    if @driver.update(@params)
      @driver
    else
      { data: { error: @driver.errors } }
    end
  end

end
