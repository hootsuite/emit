Pod::Spec.new do |s|
  s.name         = 'Emit'
  s.version      = '1.0.0'

  s.ios.deployment_target = '10.0'
  s.macos.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'

  s.summary      = "Emit is a swift Framework to support reactive binding in your iOS apps."
  s.homepage     = 'https://github.com/hootsuite/emit'
  s.license      = { type: 'Apache', file: 'LICENSE.md' }
  s.author       = { 'Hootsuite Media' => 'opensource@hootsuite.com' }
  s.source       = { git: 'https://github.com/hootsuite/emit.git', tag: "v#{s.version}" }
  s.source_files = 'Sources'
  s.swift_version = '4.2'
end
