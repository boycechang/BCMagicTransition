
Pod::Spec.new do |s| 
  s.name     = 'BCMagicMoveTransition' 
  s.version  = '1.0.2' 
  s.license  = 'MIT' 
  s.summary  = "A pretty obscure librA MagicMove Style Custom UIViewController Transitonary." 
  s.homepage = 'https://github.com/boycechang/BCMagicMoveTransition' 
  s.authors  = { 'Boyce Chang' => 
                 'boyce.chang89@gmail.com' } 
  s.social_media_url = "httr://www.boycechang.com" 
  s.source   = { :git => 'https://github.com/boycechang/BCMagicMoveTransition.git', :tag => '1.0.2' } 
  s.source_files = 'MagicTransition/BCMagicMoveTransition'
  s.ios.deployment_target = '7.0' 
  s.frameworks = 'UIKit'
end 
