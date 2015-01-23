Pod::Spec.new do |s|
	s.name = "RelapSDK"
	s.version = "0.0.1"
	s.summary = "Relap.io iOS SDK"
	s.homepage = "https://github.com/relap-io/relap-ios-sdk"
	s.license = { :type => 'MIT', :file => 'LICENSE' }
	s.author = { "Username" => "igorkamenev@yandex.ru" }
	s.platform = :ios, 7.0
    s.source = { :git => "https://github.com/relap-io/relap-ios-sdk.git", :tag => s.version.to_s }	
	s.public_header_files = 'Relap SDK Classes/*.h'
	s.source_files = 'RelapSDKClasses/*'
	s.framework = 'Foundation'
	s.requires_arc = true
end
