Pod::Spec.new do |s|
  s.name     = 'MDCalendar'
  s.version  = '0.0.2'
  s.license  = 'MIT'
  s.summary  = 'A modern iOS toast view that can fit your notification needs'
  s.homepage = 'https://github.com/distefam/MDCalendar'
  s.authors  = { 'Michael DiStefano' => 'cruffenach@gmail.com' }
	s.social_media_url   = "http://twitter.com/distefam"
  s.source   = { :git => 'https://github.com/distefam/MDCalendar.git' , :commit => 'e1e41c628914a2670a32609c5a1d35c4718702d4', :tag => 'v0.0.2' }
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '7.0'

  s.source_files = "MDCalendar/*.{h,m}"
end