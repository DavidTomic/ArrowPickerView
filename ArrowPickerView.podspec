Pod::Spec.new do |s|
  s.name             = 'ArrowPickerView'
  s.version          = '0.1.1'
  s.summary          = 'a picker view for dropdown form input.'

  s.description      = <<-DESC
This picker view provides nice way for selecting dropdown items when filling form!
                       DESC

  s.homepage         = 'https://github.com/DavidTomic/ArrowPickerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'David Tomić' => 'dtdavtomic@gmail.com' }
  s.source           = { :git => 'https://github.com/DavidTomic/ArrowPickerView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'Pod/ArrowPickerView.swift'

end
