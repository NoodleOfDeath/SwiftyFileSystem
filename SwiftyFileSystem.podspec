Pod::Spec.new do |s|

  s.name             = 'SwiftyFileSystem'
  s.version          = '1.0.3'
  s.summary          = 'Lightweight framework for effortlessly working with filesystems in swift.'

  s.description      = <<-DESC
SwiftyFileSystem is a lightweight wrapper framework around the Swift FileManager class with several URL extensions, built-in renaming policies when moving and copying files, common directory path/url generation methods, and file size string formatting.
                       DESC

  s.homepage         = 'https://github.com/NoodleOfDeath/SwiftyFileSystem'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NoodleOfDeath' => 'git@noodleofdeath.com' }
  s.source           = { :git => 'https://github.com/NoodleOfDeath/SwiftyFileSystem.git', :tag => s.version.to_s }

  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  s.source_files = 'SwiftyFileSystem/Classes/**/*{h,m,swift}'
  
  s.resource_bundles = {
     'SwiftyFileSystem' => [
        'SwiftyFileSystem/Assets/**/*.strings',
        'SwiftyFileSystem/Assets/**/*.stringsdict',
     ]
  }

  s.dependency 'SwiftyUTType', '~>1.0'
  
end
