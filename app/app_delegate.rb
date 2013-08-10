class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(App.bounds)
    @window.makeKeyAndVisible
    true
  end
end
