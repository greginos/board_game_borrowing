module AuthHelpers
  def sign_in_as(user)
    sign_in user
  end

  def sign_out_as(user)
    sign_out user
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :controller
end
