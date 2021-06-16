Pod::Spec.new do |s|
  s.name     = "KJEmitterView"
  s.version  = "7.0.2"
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

  s.default_subspec  = 'Kit'
  s.ios.source_files = 'KJEmitterView/KJEmitterHeader.h' 

  s.subspec 'Kit' do |xx|
    xx.source_files = "KJEmitterView/Kit/**/*"
    xx.resources = "KJEmitterView/Kit/**/*.{bundle}"
  end
  
  s.subspec 'Foundation' do |fun|
    fun.source_files = "KJEmitterView/Foundation/**/*"
  end
  
  s.subspec 'Language' do |la|
    la.source_files = "KJEmitterView/Language/**/*"
  end
  
  s.subspec 'Opencv' do |op|
    op.source_files = "KJEmitterView/Opencv/**/*"
  end
  
  s.subspec 'LeetCode' do |lc|
    lc.source_files = "KJEmitterView/LeetCode/**/*"
  end

  s.subspec 'Control' do |a|
    a.source_files = "KJEmitterView/Control/**/*"
    a.frameworks = 'QuartzCore'
  end

#  s.subspec 'Classes' do |ss|
#    ss.source_files = "KJEmitterView/Classes/**/*"
#    ss.resources = "KJEmitterView/Classes/**/*.{bundle}"
#  end
  
end


