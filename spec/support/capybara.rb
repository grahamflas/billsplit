require 'capybara/cuprite'

# Configure Capybara to use Cuprite as the JavaScript driver
# Capybara.javascript_driver = :cuprite

default_window_size = [1370, 1080]

base_options = {
  window_size: default_window_size,
  browser_options: {},
  timeout: 15
}.compact

# Capybara configuration
Capybara.register_driver(:cuprite_headless) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    base_options.merge(headless: true),
  )
end

Capybara.register_driver(:cuprite_headed) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    base_options.merge(headless: false)
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system, js: true) do
    if ENV["NO_HEADLESS"]
      driven_by :cuprite_headed, screen_size: default_window_size
    else
      driven_by :cuprite_headless
    end
  end
end
