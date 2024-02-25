# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'moviesNews' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
	
  # Pods for moviesNews
  pod 'SnapKit', '~> 5.0.0'
  pod 'Kingfisher', '7.6.1'
  pod 'Moya', '14.0.0'
  pod 'Alamofire', '5.6.2'
  pod 'lottie-ios'
  pod 'SwiftKeychainWrapper'

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

end
