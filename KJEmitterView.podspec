Pod::Spec.new do |s|
  s.name     = "KJEmitterView"
  s.version  = "6.0.1"
  s.summary  = "77 Tools"
  s.homepage = "https://github.com/yangKJ/KJEmitterView"
  s.license  = "MIT"
  s.license  = {:type => "MIT", :file => "LICENSE"}
  s.license  = "Copyright (c) 2018 yangkejun"
  s.author   = { "77" => "ykj310@126.com" }
  s.platform = :ios
  s.source   = {:git => "https://github.com/yangKJ/KJEmitterView.git",:tag => "#{s.version}"}
  s.social_media_url = 'https://www.jianshu.com/u/c84c00476ab6'
  s.requires_arc = true

  s.default_subspec = 'Kit'
  s.ios.source_files = 'KJEmitterView/KJEmitterHeader.h'

  s.subspec 'Kit' do |xx|
    xx.source_files = "KJEmitterView/Kit/**/*.{h,m}"
    xx.public_header_files = 'KJEmitterView/Kit/*.h',"KJEmitterView/Kit/**/*.h"
    xx.resources = "KJEmitterView/Kit/**/*.{bundle}"
    xx.frameworks = 'Accelerate'
  end

  s.subspec 'Foundation' do |fun|
    fun.source_files = "KJEmitterView/Foundation/**/*.{h,m}"
    fun.public_header_files = 'KJEmitterView/Foundation/*.h',"KJEmitterView/Foundation/**/*.h"
  end
  
  s.subspec 'Language' do |la|
    la.source_files = "KJEmitterView/Language/**/*.{h,m}"
    la.public_header_files = 'KJEmitterView/Language/*.h',"KJEmitterView/Language/**/*.h"
  end
  
  s.subspec 'Opencv' do |op|
    op.source_files = "KJEmitterView/Opencv/**/*"
    op.dependency 'KJEmitterView/Kit'
    op.dependency 'OpenCV', '~> 4.1.0'
  end

  s.subspec 'Control' do |a|
    a.source_files = "KJEmitterView/Control/**/*.{h,m}"
    a.public_header_files = "KJEmitterView/Control/**/*.h",'KJEmitterView/Control/*.h'
    a.frameworks = 'QuartzCore'
  end

  s.subspec 'Classes' do |ss|
    ss.source_files = "KJEmitterView/Classes/**/*.{h,m}"
    ss.public_header_files = "KJEmitterView/Classes/**/*.h",'KJEmitterView/Classes/*.h'
    ss.resources = "KJEmitterView/Classes/**/*.{bundle}"
  end
  
end


