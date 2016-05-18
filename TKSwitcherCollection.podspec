Pod::Spec.new do |s|
  s.name         = "TKSwitcherCollection"
  s.version      = "1.0.1"
  s.summary      = "A animate switcher cllection in Swift."
  s.homepage     = "https://github.com/TBXark/TKSwitcherCollection"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.author       = { "vfanx" => "tbxark@qq.com" }
  s.source       = { :git => "https://github.com/TBXark/TKSwitcherCollection.git", :tag => "1.0.0" }
  s.platform     = :ios, '8.0'
  s.source_files = 'Classes/*.swift'
  s.requires_arc = true
end
