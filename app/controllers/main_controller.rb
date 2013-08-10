class MainController < UIViewController
  DEFAULT_URL = 'https://www.google.com/'

  def loadView
    self.view = UIWebView.new
  end

  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
    initialize_hatena_bookmark_client

    if HTBHatenaBookmarkManager.sharedManager.authorized
      open_web_view
    else
      login
    end
  end

  def viewDidUnload
    App.notification_center.unobserve(@login_notification)
  end

  def dealloc
    App.notification_center.unobserve(@login_notification)
    super
  end

  def initialize_hatena_bookmark_client
    HTBHatenaBookmarkManager.sharedManager.setConsumerKey("O4pJCexwwz7/2w==", consumerSecret: "CjUwyYxHO7dBOuTuZBebfPj8jpE=")
    @login_notification = App.notification_center.observe(KHTBLoginStartNotification) do |notif|
      show_oauth_login_view(notif.object)
    end
  end

  def login
    HTBHatenaBookmarkManager.sharedManager.authorizeWithSuccess(
        lambda {
          open_web_view
        },
        failure: lambda {|error|
          puts error.localizedDescription
        }
    )
  end

  def open_web_view
    url = NSURL.URLWithString(DEFAULT_URL)
    request = NSURLRequest.requestWithURL(url)
    view.loadRequest(request)
  end

  def show_oauth_login_view(request)
    nav = UINavigationController.alloc.initWithNavigationBarClass(HTBNavigationBar, toolbarClass: nil)
    login_controller = HTBLoginWebViewController.alloc.initWithAuthorizationRequest(request)
    nav.viewControllers = [login_controller]
    self.presentViewController(nav, animated: true, completion: nil)
  end
end