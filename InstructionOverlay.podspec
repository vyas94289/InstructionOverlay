Pod::Spec.new do |s|
  s.name         = 'InstructionOverlay'
  s.version      = '1.0.0'
  s.summary      = 'Instruction Overlay'
  s.description  = <<-DESC
                   Easy to create instruction over specific view
                   DESC
  s.homepage     = 'https://github.com/vyas94289/InstructionOverlay'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Gaurang Vyas' => 'vsgaurang@gmail.com' }
  s.source       = { :git => 'git@github.com:vyas94289/InstructionOverlay.git', :tag => '#{s.version}' }
  s.platform     = :ios, '13.0'
  s.swift_version = '5.0'
  s.source_files  = 'Sources/*.{swift}'
end
