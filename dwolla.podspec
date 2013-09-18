Pod::Spec.new do |s|
  s.name         = "dwolla-ios"
  s.platform 	 = :ios, '5.0'
  s.summary      = "Dwolla integration needed files"
  s.homepage     = "https://github.com/jailanigithub/dwolla-ios"
  s.author       = { "Jailani" => "jailaninice@gmail.com" }
  s.source       = { :git => "https://github.com/jailanigithub/dwolla-ios.git"}
  s.source_files = 'DwollaOAuthLib','DwollaOAuthLib/**/*.{h,m}'
  s.requires_arc = false
  s.frameworks = 'CoreGraphics', 'QuartzCore', 'Foundation', 'SenTestingKit' 
end  
