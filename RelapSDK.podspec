Pod::Spec.new do |s|
	s.name = "RelapSDK"
	s.version = "0.0.1"
	s.summary = "Relap.io SDK"
	s.homepage = "https://github.com/igorkamenev/relapsdk"
	s.license = { :type => 'MIT', :file => 'LICENSE' }
	s.author = { "Username" => "igorkamenev@yandex.ru" }
	s.platform = :ios, 7.0
	s.source = { :git => "https://github.com/igorkamenev/relapsdk.git", :tag => s.version.to_s }
	s.framework = 'Foundation'
	s.requires_arc = true
	s.default_subspec = 'Core'
	
	s.subspec 'Core' do |core|
		core.source_files = 'Relap SDK Classes/*.{m.h}'
		core.public_header_files = 'Relap SDK Classes/*.h'
	end	
end
