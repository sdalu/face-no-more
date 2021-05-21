# -*- encoding: utf-8 -*-

require_relative 'lib/face-no-more/version'

Gem::Specification.new do |s|
    s.name        = 'face-no-more'
    s.version     = FaceNoMore::VERSION
    s.summary     = "Generate avatars"
    s.description = "Convert SSH public key from/to RFC4716/OpenSSH format"
    s.homepage    = 'https://gitlab.com/sdalu/face-no-more'
    s.license     = 'MIT'

    s.authors     = [ "Stéphane D'Alu" ]
    s.email       = [ 'stephane.dalu@insa-lyon.fr' ]

    s.files       = %w[ README.md face-no-more.gemspec ] +
                    Dir['lib/**/*.rb'] + Dir['data/**']

    s.add_dependency 'rmagick'
    s.add_development_dependency 'yard', '~>0'
    s.add_development_dependency 'rake', '~>13'
end
