# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'Mazaady' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Mazaady
  pod 'Alamofire'
  pod 'NVActivityIndicatorView'
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'ReachabilitySwift'

  target 'MazaadyTests' do
    inherit! :search_paths
    # Pods for testing
  pod 'Alamofire'
  pod 'NVActivityIndicatorView'
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'ReachabilitySwift'
  end

  target 'MazaadyUITests' do
    # Pods for testing
  end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
		end
	end
end
end
