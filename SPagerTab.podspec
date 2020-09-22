Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "SPagerTab"
s.summary = "PagerTab is a custom pager with a top bar."
s.requires_arc = true

# 2
s.version = "0.2.2"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Suhaib Al Saghir" => "suhaib.al.saghir@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/sub96/PagerTab"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/sub96/PagerTab.git", :tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "PagerTab/**/*.{h,m,swift,storyboard,xib}"

# 9
# s.resources = "PagerTab/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
