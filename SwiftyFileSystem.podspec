#
# Be sure to run `pod lib lint SwiftyFileSystem.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyFileSystem'
  s.version          = '1.0.2'
  s.summary          = 'Lightweight framework for effortlessly working with filesystems in swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SwiftyFileSystem is a lightweight wrapper framework around the Swift FileManager class with several URL extensions, built-in renaming policies when moving and copying files, common directory path/url generation methods, and file size string formatting.
                       DESC

  s.homepage         = 'https://github.com/NoodleOfDeath/SwiftyFileSystem'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NoodleOfDeath' => 'git@noodleofdeath.com' }
  s.source           = { :git => 'https://github.com/NoodleOfDeath/SwiftyFileSystem.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  s.source_files = 'SwiftyFileSystem/Classes/**/*{h,m,swift}'
  
  s.resource_bundles = {
     'SwiftyFileSystem' => [
        'SwiftyFileSystem/Assets/**/*.strings',
        'SwiftyFileSystem/Assets/**/*.stringsdict',
     ]
  }

  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SwiftyUTType'
  
end
