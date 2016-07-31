#
# Be sure to run `pod lib lint MBTaskContainer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MBTaskContainer'
  s.version          = '0.1.1'
  s.summary          = 'Multi-threaded NSURLSessionTask container'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
You have a good separation of UI and data/network but you make multiple network requests at data layer and you are having troubles with notifying UI layer about that?
You don't want to have extra notifying parameter in your data layer classes and you don't wanna deal with blocks/delegate methods?
You don't wanna use ReactiveCocoa since it is huge and a totally different paradigm?
Then you are at the right place! MBTaskContainer is for you! Return it to UI layer from data layer and then you can modify if from any thread and layer!
UI layer can query  active tasks with safety whenever it wants.
			 DESC

  s.homepage         = 'https://github.com/buranmert/MBTaskContainer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mert Buran' => 'buranmert@gmail.com' }
  s.source           = { :git => 'https://github.com/buranmert/MBTaskContainer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lazymanandbeard'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MBTaskContainer/Classes/**/*'
  s.frameworks = 'Foundation'
end
