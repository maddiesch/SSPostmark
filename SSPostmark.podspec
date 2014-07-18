Pod::Spec.new do |s|
  s.name             = "SSPostmark"
  s.version          = "1.0.0"
  s.summary          = "Full featured Objective-C wrapper for the Postmark API."
  s.homepage         = "https://github.com/skylarsch/SSPostmark"
  s.license          = "MIT"
  s.author           = { "Skylar Schipper" => "ss@schipp.co" }
  s.social_media_url = "http://twitter.com/skylarsch"
  s.platform         = :ios, "7.1"
  s.source           = { :git => "https://github.com/skylarsch/SSPostmark.git", :tag => s.version.to_s }
  s.source_files     = "SSPostmark/SSPostmark/*.{h,m}"
  s.exclude_files    = "SSPostmark/SSPostmark/Private Headers"
  s.requires_arc     = true
end
