Description
===========

Allow generating avatar pictures from ruby.

The supported avatar type are: `cat`, `bird`, `abstract`, `mobilizon`,
`8bit-female` and `8bit-male`.


Examples
========

~~~ruby
require 'face-no-more'

# Number of possible avatars
count = FaceNoMore.possibilities(:mobilizon)

# Generate avatar picture
jpg = FaceNoMore.generate(:cat, "foo@example.com", format: :jpg, size: 256)
png = FaceNoMore.generate(:bird, 12345678910)
~~~



Artworks
========
* `cat`, `bird`, `abstract` and `mobilizon` are from [David Revoy][2]
  licensed under [CC-By 4.0][4]
* `8bit-female` and `8bit-male` are from [matveyco][3]



[2]: http://www.peppercarrot.com
[3]: https://github.com/matveyco/8biticon
[4]: http://creativecommons.org/licenses/by/4.0/

