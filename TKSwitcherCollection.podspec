Pod::Spec.new do |s|
  s.name         = "TKSwitcherCollection"
  s.version      = "2.0.0"
  s.summary      = "An animated switch collection for UIKit and SwiftUI."
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.homepage     = "https://github.com/TBXark/TKSwitcherCollection"
  s.author       = { "TBXark" => "tbxark@outlook.com" }
  s.source       = { :git => "https://github.com/TBXark/TKSwitcherCollection.git", :tag => s.version }
  s.platform     = :ios, '13.0'
  s.swift_version = '5.9'
  s.source_files = 'Sources/TKSwitcherCollection/**/*.swift'
  s.requires_arc = true
end
