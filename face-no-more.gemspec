# -*- encoding: utf-8 -*-

require_relative 'lib/face-no-more/version'

Gem::Specification.new do |s|
    s.name        = 'face-no-more'
    s.version     = FaceNoMore::VERSION
    s.summary     = "Generate avatars"
    s.description =  <<~EOF
      Generate avatars from artwork assets.
      Included 5 different types of artwork: cat, bird, abstract, mobilizon, and 8bit.
      EOF

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
