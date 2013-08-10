# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
Bundler.require :default

require 'yaml'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'hatena_sample'
  app.version = '1.0.0'
  app.short_version = app.version
  app.deployment_target = '6.0'
  app.prerendered_icon = false
  app.device_family = :iphone
  #app.device_family = [:ipad, :iphone]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right]
  app.detect_dependencies = false

  conf_file = './config.yml'
  if File.exists?(conf_file)
    config = YAML::load_file(conf_file)

    # TestFlight
    unless config['testflight']['api_token'].nil?
      app.testflight.sdk        = 'vendor/TestFlightSDK'
      app.testflight.api_token  = config['testflight']['api_token']
      app.testflight.team_token = config['testflight']['team_token']
      app.testflight.notify     = true
      app.testflight.distribution_lists = config['testflight']['distribution_lists']
    end

    # Pixate
    unless config['pixate']['user'].nil?
      app.pixate.user = config['pixate']['user']
      app.pixate.key  = config['pixate']['key']
      app.pixate.framework = 'vendor/PXEngine.framework'
    end

    app.identifier = config['identifier']
    app.info_plist['CFBundleURLTypes'] = [
        {
            'CFBundleURLName' => config['identifier'],
            'CFBundleURLSchemes' => [config['identifier']]
        }
    ]

    env = ENV['ENV'] || 'development'
    app.codesign_certificate = config[env]['certificate']
    app.provisioning_profile = config[env]['provisioning']
  end

  app.files += []
  app.frameworks += []
  app.weak_frameworks += []
  app.libs += []


  app.pods do
    pod 'HatenaBookmarkSDK', :git => 'git@github.com:hatena/Hatena-Bookmark-iOS-SDK.git'
    pod 'SVWebViewController'
  end


  app.development do
    #app.entitlements['aps-environment'] = 'development'
    app.entitlements['get-task-allow'] = true
  end
  app.release do
    #app.entitlements['aps-environment'] = 'production'
    app.entitlements['get-task-allow'] = false
  end

  #app.info_plist['UIRequiredDeviceCapabilities'] = []
end

desc "Set the env to 'adhoc'"
task :set_adhoc do
  ENV['ENV'] = 'adhoc'
end

desc "Run Testflight with the adhoc provisioning profile"
# e.g. rake tf notes="My release notes"
task :tf => [
    :set_adhoc,
    :testflight
]
