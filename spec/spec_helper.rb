require 'appium_lib'

Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }
