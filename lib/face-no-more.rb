# coding: utf-8
require 'securerandom'
require 'digest'
require 'rmagick'


# Generate avatar
#
# ~~~ruby
# require 'face-no-more'
# 
# FaceNoMore.generate(:cat, "foo@example.com", format: :jpg, size: 256)
# FaceNoMore.generate(:bird, 12345678910)
# ~~~


module FaceNoMore
    # @!visibility private
    IMAGES_DIR   = File.join(__dir__, '..', 'data', 'images')

    # @!visibility private
    # NOTE: - Limited to 16 parts
    #       - Keep sizes sorted from small to big
    DESCRIPTIONS = {
        :cat => {
            :author     => 'David Revoy',
            :license    => 'CC-BY',
            :src        => 'https://www.peppercarrot.com/extras/html/2016_cat-generator/',
            :sizes      => [ 256 ],
            :partname   => "%<part>s_%<id>d.png",
            :parts      => { :body        => 1..15,
                             :fur         => 1..10,
                             :eyes        => 1..15,
                             :mouth       => 1..10,
                             :accessorie  => 1..20 },
            
        },
        :bird => {
            :author     => 'David Revoy',
            :license    => 'CC-BY',
            :src        => 'https://www.peppercarrot.com/extras/html/2019_bird-generator/',
            :sizes      => [ 256 ],
            :partname   => "%<part>s_%<id>d.png",
            :parts      => { :tail        => 1..9,
                             :hoop        => 1..10,
                             :body        => 1..9,
                             :wing        => 1..9,
                             :eyes        => 1..9,
                             :bec         => 1..9,
                             :accessorie  => 1..20, },
        },
        :abstract => {
            :author     => 'David Revoy',
            :license    => 'CC-BY',
            :src        => 'https://www.peppercarrot.com/extras/html/2017_abstract-generator/',
            :sizes      => [ 256 ],
            :partname   => "%<part>s_%<id>d.png",
            :parts      => { :body        => 1..15,
                             :fur         => 1..10,
                             :eyes        => 1..15,
                             :mouth       => 1..10, },
        },
        :mobilizon => {
            :author     => 'David Revoy',
            :license    => 'CC-BY',
            :src        => 'https://www.peppercarrot.com/extras/html/2020_mobilizon-generator/',
            :sizes      => [ 256, 1024 ],
            :partname   => "%<part>s_%<id>02d.png",
            :parts      => { :body        => 1..25,
                             :nose        => 1..10,
                             :tail        => 1..5,
                             :eyes        => 1..10,
                             :mouth       => 1..10,
                             :accessories => 1..20,
                             :misc        => 1..20,
                             :hat         => 1..20, },
        },
        :'8bit-female' => {
            :author     => 'matveyco',
            :src        => 'https://github.com/matveyco/8biticon',
            :path       => '8bit/female',
            :sizes      => [ 400 ],
            :partname   => "%<part>s%<id>d.png",
            :parts      => { :face        => 1..4,
                             :clothes     => 1..59,
                             :mouth       => 1..17,
                             :head        => 1..33,
                             :eye         => 1..53, },
        },
        :'8bit-male' => {
            :author     => 'matveyco',
            :src        => 'https://github.com/matveyco/8biticon',
            :path       => '8bit/male',
            :sizes      => [ 400 ],
            :partname   => "%<part>s%<id>d.png",
            :parts      => { :face        => 1..4,
                             :clothes     => 1..65,
                             :mouth       => 1..26,
                             :hair        => 1..36,
                             :eye         => 1..32, },
        },
    }


    # List of supported avatar types
    TYPES = DESCRIPTIONS.keys.freeze

    
    # Return the number of different avatar possible
    #
    # @param type type of avatar
    #
    # @return [Integer]
    #
    def self.possibilities(type)
        DESCRIPTIONS.fetch(type) {
            raise ArgumentError, "unsupported type (#{type})"
        }[:parts].map {|part, range| range.last - range.first }
                 .reduce(:*)
    end

    
    # Generate an avatar
    #
    # @param type    [Symbol]  type of avatar
    # @param seed    [String,Array<Integer>,Integer,nil] seed
    # @param format  [:Symbol] picture format (as defined in ImageMagick)
    # @param quality [Integer] picture quality (1..100)
    # @param size    [Integer] picture size
    #
    # @return [String]
    #
    def self.generate(type, seed = nil, format: :png, quality: 90, size: 256)
        desc      = DESCRIPTIONS.fetch(type) {
                        raise ArgumentError, "unsupported type (#{type})" }
        parts     = desc[:parts]
        sizes     = desc[:sizes]
        path      = File.join(IMAGES_DIR, desc[:path] || type.to_s)
        partsize  = sizes.find {|s| size > s } || sizes.last
        seedbytes = case seed
                    when nil     then SecureRandom.random_bytes(16).bytes
                    when String  then Digest::MD5.digest(seed).bytes
                    when Array   then seed
                    when Integer then parts.map {|_, r|
                                          count     = r.end - r.begin + 1
                                          seed, val = seed.divmod(count)
                                          val }
                    end

        if parts.size > seedbytes.size
            raise ArgumentError, "seed doesn't hold enough elements"
        end


        files = parts.each_with_index.map {|(part, range), index|
                    mod = (range.end - range.begin) + 1
                    id  = range.first + seedbytes[index] % mod
                    File.join(path, partsize.to_s,
                              desc[:partname] % { :part => part, :id   => id })
                }
        
        Magick::ImageList.new(*files).flatten_images
            .change_geometry!("#{size}x#{size}") { |cols, rows, me|
                me.thumbnail!(cols, rows)
            }.to_blob {|me| me.format  = format.to_s
                            me.quality = quality }
    end    
end
