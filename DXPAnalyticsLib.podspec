Pod::Spec.new do |spec|
  spec.name         = "DXPAnalyticsLib"
  spec.module_name  = "DXPAnalyticsLib"
  spec.version      = "1.0.32"
  spec.summary      = "DXP Analytics Manager."
  spec.description  = "DXP Analytics Manager SDK with native Swift and Objective-C APIs."
  spec.homepage     = "https://github.com/HelloGitHub123/DXPAnalyticsLib"
  spec.license      = "MIT"
  spec.author             = { "李标" => "li.biao3@iwhalecloud.com" }

  spec.platform     = :ios, "12.2"
  spec.swift_versions = ['5.0']
  spec.source       = { :git => "https://github.com/HelloGitHub123/DXPAnalyticsLib.git", :tag => "#{spec.version}" }

  spec.source_files  = "DXPAnalyticsLib/**/*.{h,m,swift}"
  spec.public_header_files = [
    "DXPAnalyticsLib/DXPAnalyticsLib.h",
    "DXPAnalyticsLib/DxpTrace.h",
    "DXPAnalyticsLib/EventTraceData.h",
    "DXPAnalyticsLib/GoogleAnalyticsManagement.h",
    "DXPAnalyticsLib/SensorsManagement.h",
    "DXPAnalyticsLib/SwiftBridge.h"
  ]
  spec.header_mappings_dir = "DXPAnalyticsLib"

  spec.requires_arc = true
  spec.static_framework = true

  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'CLANG_ENABLE_MODULES' => 'YES'
  }
  spec.user_target_xcconfig = {
    'CLANG_ENABLE_MODULES' => 'YES',
    'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => 'NO'
  }

  spec.dependency 'SensorsAnalyticsSDK/Core','~> 4.9.1'
  spec.dependency 'SensorsAnalyticsSDK/Exception','~> 4.9.1'
  spec.dependency 'Firebase/Analytics','~> 11.10.0'
end
