
Pod::Spec.new do |s| 
  s.name     = 'BCMagicTransition' 
  s.version  = '1.0.3' 
  s.license  = 'MIT' 
  s.summary  = "A MagicMove Style Custom UIViewController Transiton." 
  s.homepage = 'https://github.com/boycechang/BCMagicTransition' 
  s.authors  = { 'Boyce Chang' => 
                 'boyce.chang89@gmail.com' } 
  s.social_media_url = "httr://www.boycechang.com" 
  s.source   = { :git => 'https://github.com/boycechang/BCMagicTransition.git', :tag => '1.0.3' } 
  s.source_files = 'MagicTransition/BCMagicTransition'
  s.ios.deployment_target = '7.0' 
  s.frameworks = 'UIKit'
  s.requires_arc = true
end 
