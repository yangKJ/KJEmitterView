# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

#use_frameworks!
#inhibit_all_warnings! #消除第三方仓库的警告
# 新版本采用trunk模式，无需clone庞大的master
#source 'https://github.com/CocoaPods/Specs.git'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = "NO"
    end
  end
end

#install! 'cocoapods', generate_multiple_pod_projects: true

target 'KJEmitterView' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'GZIP'
  pod "Toast"
  pod "FDFullscreenPopGesture"
  pod "DZNEmptyDataSet"
  pod 'OpenCV', '~> 4.1.0'

  # Pods for KJEmitterView

end
