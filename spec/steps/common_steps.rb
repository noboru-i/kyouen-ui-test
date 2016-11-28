# coding: utf-8

module CommonSteps
  step 'スプラッシュを待つ' do
    sleep 10
  end

  step ':screen_id の :element_id が表示されていること' do |screen_id, element_id|
    element = search_element(screen_id, element_id)
    expect(element).to be_truthy
  end

  step ':screen_id の :element_id をタップする' do |screen_id, element_id|
    element = search_element(screen_id, element_id)
    element.click
  end

  step ':target としてキャプチャする' do |target|
    sleep 1
    ss_dir = 'ss'
    Dir.mkdir ss_dir unless FileTest.exist? ss_dir

    @ss_count ||= 0
    file_name = format('%03d_%s', @ss_count, target)
    @appium_driver.screenshot ss_dir + '/' + file_name + '.png'
    @ss_count += 1
  end

  step 'アラートでOKを押す' do
    driver.switch_to.alert.accept
  end

  def search_element(screen_id, element_id)
    id = format('%s_%02d', screen_id, element_id)
    driver.find_element :id, id
  end

  def init_driver(os)
    @device = os
    case os
    when 'android'
      desired_caps = {
        caps: {
          deviceName:   :android,
          platformName: :android,
          app:          '../app/build/outputs/apk/app-debug.apk',
          appWaitActivity:  'hm.orz.chaos114.android.tumekyouen.modules.initial.InitialActivity,hm.orz.chaos114.android.tumekyouen.modules.title.TitleActivity'
        },
        appium_lib: {
          wait: 10
        }
      }
    when 'iOS'
      desired_caps = {
        caps: {
          deviceName:   'iPhone 6s',
          platformName: 'iOS',
          platformVersion: '10.1',
          app:          '../build/Build/Products/AdHoc-iphonesimulator/TumeKyouen.app',
          autoAcceptAlerts: true,
          automationName: 'XCUITest'
        },
        appium_lib: {
          wait: 10
        }
      }
    end
    @appium_driver ||= Appium::Driver.new(desired_caps)
    @appium_driver
  end

  def driver
    case @device
    when 'android'
      @driver ||= @appium_driver.start_driver
      @driver.manage.timeouts.implicit_wait = 60
    when 'iOS'
      @driver ||= @appium_driver.start_driver
      @driver.manage.timeouts.implicit_wait = 60
    end
    @driver
  end

  def cleanup
    if @driver
      driver.quit
      @driver = nil
    end
  end
end

RSpec.configure do |conf|
  conf.include CommonSteps

  conf.before(:each) do
    init_driver(ENV['OS'])
  end
  conf.after(:each) do
    cleanup
  end
end
