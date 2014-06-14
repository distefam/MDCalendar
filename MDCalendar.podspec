Pod::Spec.new do |s|
  s.name     = 'MDCalendar'
  s.version  = '0.0.1'
  s.license  = { :type => 'MIT' }
  s.summary  = 'A calendar-style date picker for iOS 7 (and above) that uses `UICollectionView` to layout a calendar in the popular "month view" format.'
  s.homepage = 'https://github.com/distefam/MDCalendar'
  s.authors  = { 'Michael DiStefano' => 'm@simple.com' }
	s.social_media_url   = "http://twitter.com/distefam"
  s.source   = { :git => 'https://github.com/distefam/MDCalendar.git' , :tag => 'v0.0.1' }
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.source_files = "MDCalendar/*.{h,m}"
end