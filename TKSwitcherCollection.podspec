Pod::Spec.new do |s|
  s.name         = "TKSwitcherCollection"
  s.version      = "1.4.3"
  s.summary      = "A animate switcher cllection in Swift."
  s.license      = { :type => 'MIT License', :file => 'LICENSE' } # 协议
  s.homepage     = "https://github.com/TBXark/TKSwitcherCollection"
  s.author       = { "TBXark" => "tbxark@outlook.com" }
  s.source       = { :git => "https://github.com/TBXark/TKSwitcherCollection.git", :tag => s.version }
  s.platform     = :ios, '8.0'
  s.source_files = 'TKSwitcherCollection/*.swift'
  s.requires_arc = true
end
