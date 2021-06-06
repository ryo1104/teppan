Capybara.default_driver = :rack_test
# Capybara.register_driver :selenium_chrome_headless do |app|
#     browser_options = ::Selenium::WebDriver::Chrome::Options.new()
#     browser_options.args << '--headless'
#     browser_options.args << '--no-sandbox'
#     browser_options.args << '--disable-gpu'
#     Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
# end
Capybara.register_driver :selenium_chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  # options.add_argument('--no-sandbox')
  # options.add_argument('--disable-extensions')
  # options.add_argument('--disable-infobars')
  # options.add_argument('--disable-dev-shm-usage')
  # options.add_argument('--user-data-dir=./User_Data')
  # options.add_argument('--window-size=1400,1400')
  # options.add_argument('--remote-debugging-port=0')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.javascript_driver = :selenium_chrome_headless
