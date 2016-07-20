Pod::Spec.new do |spec|
  spec.name = 'NPOKit'
  spec.version = '1.0.0'
  spec.summary = 'NPOKit framework for interfacing with the Nederlandse Publieke Omroep (NPO: the Dutch public broadcaster.)'
  spec.homepage = 'https://github.com/4np/NPOKit'
  spec.license = { type: 'APACHE', file: 'LICENSE' }
  spec.authors = { "Jeroen Wesbeek" => 'github@osx.eu' }
  spec.documentation_url = 'https://github.com/4np/NPOKit/blob/master/README.md'

  spec.platform = :tvos, '9.0'
  spec.requires_arc = true
  spec.source = { git: 'https://github.com/4np/NPOKit.git', submodules: true }
  spec.source_files = "NPOKit/**/*.{h,swift}"

  spec.dependency 'CocoaLumberjack/Swift'
  spec.dependency 'Alamofire', '~> 3.4'
  spec.dependency 'AlamofireObjectMapper', '~> 3.0'
  spec.dependency 'AlamofireImage', '~> 2.0'
  spec.dependency 'RealmSwift'
end