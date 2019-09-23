#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'cybex_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin with cybex crypto'
  s.description      = <<-DESC
A new Flutter plugin with cybex crypto
                       DESC
  s.homepage         = 'https://cybex.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'koofrank' => 'koofranker@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '11.0'
  
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(PROJECT_DIR)/../ $(PROJECT_DIR)/../Frameworks $(PROJECT_DIR)/../Carthage/Build/iOS' }
  s.frameworks = 'cybex_ios_core_cpp', 'SwiftyJSON'
end

