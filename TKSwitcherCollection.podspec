Pod::Spec.new do |s|
  s.name         = "TKSwitcherCollection"
  s.version      = "1.0.2"
  s.summary      = "A animate switcher cllection in Swift."
  s.homepage     = "https://github.com/TBXark/TKSwitcherCollection"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.author       = { "vfanx" => "tbxark@outlook.com" }
  s.source       = { :git => "https://github.com/TBXark/TKSwitcherCollection.git", :tag => s.version }
  s.platform     = :ios, '8.0'
  s.source_files = 'SwitcherCollection/Classes/*.swift'
  s.requires_arc = true
end
