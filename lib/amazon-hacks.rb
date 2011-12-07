require 'rubygems'
require 'uri'
require 'color'

class AmazonHacks
  VERSION = '0.5.1'
end

module Amazon
  module Hacks
    Country = Struct.new("Country", :country, :host, :img_code, :img_host)
    
    ##
    # COUNTRIES is nice generic structure for storing information specific to
    # each country Amazon has a store for (China seems special though, so I have
    # deferred supporting it for now)
    COUNTRIES = {
        :ca => Country.new(:ca, "www.amazon.ca", "01", "images.amazon.ca"),
      #        :cn => new Location("www.amazon.cn", ) 
        :de => Country.new(:de, "www.amazon.de", "03", "images.amazon.de"),
        :fr => Country.new(:fr, "www.amazon.fr", "08", "images.amazon.fr"),
        :jp => Country.new(:jp, "www.amazon.co.jp", "09", "images.amazon.co.jp"),
        :uk => Country.new(:uk, "www.amazon.co.uk", "02", "images.amazon.co.uk"),
        :us => Country.new(:us, "www.amazon.com", "01", "images.amazon.com")
    }
    
    ##
    # The countries module is a convenience mixin to retrieve the correct
    # server, etc. for an Image or Link. This module requires the class to
    # include a @country instance variable.
    module Countries
      
      ##
      # Returns a hostname for the Amazon store for that country
      def country_host 
        COUNTRIES[@country].host
      end
      
      ##
      # Each country in Amazon seems to use a different image code number in its
      # images (eg, "01" for the US, "08" for France). This method returns the
      # image code for the country
      def country_imgcode
        COUNTRIES[@country].img_code
      end
      
      ##
      # Each country also has a different server for its images. This returns
      # the correct server.
      def country_imghost
        COUNTRIES[@country].img_host
      end
    end

    class Link
      include Countries
      attr_reader :asin, :country      
      
      def initialize(url=nil, country=nil, asin=nil)
        if url.nil?
          @url = @country = @asin = nil
        else
          @url = URI.parse(url)
          @country = country ? country : Amazon::Hacks::Link.extract_country(url)
          @asin = asin ? asin : Amazon::Hacks::Link.extract_asin(url)
        end
      end

      ##
      # Sets the internal url of the link to be +url+. Also parses the values of
      # the +asin+ and +country+ from the URL
      def url=(url)
        @url = URI.parse(url)
        @country = Amazon::Hacks::Link.extract_country(url)
        @asin = Amazon::Hacks::Link.extract_asin(url)
      end

      ##
      # Returns a normalized form of the Link's URL. This is the shortest valid
      # URL that links to the product on Amazon
      #
      # For example, the normalized form of a URL like:
      #
      # http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672/sr=8-1/qid=1165273301/ref=pd_bbs_sr_1/002-2410048-1716806?ie=UTF8&s=books
      #
      # would be:
      #
      # http://www.amazon.com/o/asin/0201485672
      #
      # Since it removes the session and other variables from the URL, 
      # normalization is very useful for comparing two Amazon links directly.
      # The Link== method does NOT normalize, but you might want to consider
      # that if you need it.
      def normalize
        "http://#{country_host}/o/asin/#{asin}"
      end

      ##
      # Extracts the Amazon Standard Identification Number (ASIN) from a string +url+. 
      # Each product on an Amazon store has a unique ASIN used to identify it. 
      # As Amazon's help documents describe it:
      #
      # "For books, the ASIN is the same as the ISBN number, but for all other 
      # products a new ASIN is created when the item is uploaded to our catalog"
      #
      # ASIN values are specific to the store they're applied to and can not be
      # used against another store nor are they guaranteed to be globally unique.
      # Put another way, the ASIN for the US edition of a book will not return
      # the UK edition when used with the UK store and might return nothing or
      # something completely different. Also, ASINs are alphanumeric strings, not
      # numbers.
      #
      # Amazon has used several different major URL formats interchangeably and
      # this function extracts the ASIN from the following URL paths:
      #
      # /o/asin/<ASIN VALUE>[/...]
      #
      # /exec/obidos/ASIN/<ASIN VALUE>[/...]
      #
      # /exec/obidos/tg/detail/-/<ASIN VALUE>[/...]
      #
      # /long-title-goes-here/dp/<ASIN VALUE>[/...]
      #
      # This is only an informally gathered list. If you find a case where 
      # +extract_asin+ fails, please send me the URL. If the ASIN is not matched,
      # returns +nil+
      def Link.extract_asin(url)  
        u = URI.parse(url)
        asin = nil

        asin_regexps = [ /^\/o\/asin\/([^\/]+)/, 
          /^\/exec\/obidos\/ASIN\/([^\/]+)/, 
          /^\/exec\/obidos\/tg\/detail\/-\/([^\/]+)/, 
          /^\/[^\/]+\/dp\/([^\/]+)/,
          /^\/[^\/]+\/product\/([^\/]+)/ 
        ]
        
        asin_regexps.each do |re|
          md = re.match(u.path)
          if md
          then
            asin = md[1]
            break
          end
        end
        
        asin
      end

      ##
      # This method analyzes the +url+ string and returns a symbol representing
      # the country (eg, +:us+). If the host is not recognized, returns +nil+
      def Link.extract_country(url)
        u = URI.parse(url)
        c = COUNTRIES.find { |key, value| value.host == u.host }
        c[0] unless c.nil? #.country unless c.nil? 
      end

      ##
      # Returns a normalized URL for the product with an Amazon Associate ID
      # appended to it.
      def associate_url(assoc_id)
       normalize + "/#{assoc_id}"
      end

      ##
      # Like #normalize, but changes the internal url
      def normalize!
        u = normalize
        @url = URI.parse(u)
        self
      end

      ##
      # Returns the saved URL
      def url
        @url.to_s
      end
      
      ##
      # The to_s method returns the internal URL.
      alias :to_s :url
    end
 end
end

module Amazon
  module Hacks
    
    ##
    # Class for manipulating Amazon's image URLs. These images are generated
    # on demand at Amazon, so please don't abuse this feature against their
    # site (save the image locally or link to them so they can get some sales
    # out of it). I also do not have transformations that apply Amazon-specific
    # decorations like "20% off" badges or "Look Inside" to hinder spoofing an
    # Amazon site somewhat.
    #
    # Amazon images require an ASIN and country. These can either be specified
    # manually or imported from a URL. In addition, each image can be modified
    # with zero or more transformations (all specified in the URL), although the
    # using more than two transformations is not necessarily guaranteed to be 
    # honored by Amazon's rendering engine (only the first will generally be 
    # applied, but [size + transform] seems to work usually).
    #
    # {Abusing Amazon Images}[http://aaugh.com/imageabuse.html], a site to whom
    # I am most indebted here, notes the following about transform chaining:
    #
    # "The cool thing (if you want to generate unlikely Amazon images) is that 
    # you're not limited to one use of any of these commands. You can have 
    # multiple discounts, multiple shadows, multiple bullets, generating images 
    # that Amazon would never have on its site. However, every additional command 
    # you add generates another 10% to the image dimensions, adding white space 
    # around the image. And that 10% compounds; add a lot of bullets, and you'll
    # find that you have a small image in a large blank space. (You can use the 
    # #crop! command to cut away the excess, however.) Note also that the commands 
    # are interpreted in order, which can have an impact on what overlaps what."
    class Image
      include Countries
      attr :asin, :country
      
      SIZES = { :small => "SCTZZZZZZZ", 
                :medium => "SCMZZZZZZZ", 
                :large => "SCLZZZZZZZ" }
                
      SHADOW_POSITIONS = [ :left, :right, :custom ]      
      
      SCALE_TYPES = { :proportion => "AA", 
                      :square => "SS", 
                      :width => "SX", 
                      :height => "SY" }
      
      TEXT_FONTS = [ :times, :arial, :arialbi, :verdanab, :advc128d ]
      TEXT_ALIGNS = [ :left, :center ]
      
      ##
      # Creates an Image object from a +url+  
      def Image.build_from_url(url)
        u = Amazon::Hacks::Link.new(url)
        return nil if u.asin.nil? || u.country.nil?
        i = Image.new(u.asin, u.country)        
      end
      
      ##
      # Initializes an Image object, requires both a valid asin as well as
      # a country symbol (eg, +:us+ or +:uk+)
      def initialize(asin, country)
        @asin = asin
        @country = country
        reset_transforms!
      end
      
      ##
      # Add a size transform to the image. The following sizes are allowed:
      # * small
      # * medium
      # * large
      #
      # These sizes are not guaranteed to particular dimensions. If you need
      # exact sizing, use the #scale! transformation. These sizes are a lot
      # friendlier to Amazon's image servers though, so I would recommend them
      # if you can handle some variation.
      def set_size!(size) 
        @transforms << SIZES[size]
        self        
      end  
      
      ##
      # Add a simple shadow to the left or right; takes arguments :left or
      # :right. 
      def add_shadow! (side)
        case 
        when side == :left then @transforms << "PB" 
        when side == :right then @transforms << "PC"
        end       
        self
      end
      
      ##
      # Add a custom shadow to the image. Takes 4 parameters:
      #
      # * +size+ - padding around the image (pixels)
      # * +xoff+ - distance from the shadow's edge to the item's edge horizontally. 
      #   Positive values go to the right, negative to the left (pixels)
      # * +yoff+ - like xoff but vertically.
      # * +fuzz+ - fuzziness of shadow; 0 is perfectly square while higher values
      #   blur the sharpness of the shadow's edge
      def add_custom_shadow! (size, xoff, yoff, fuzz)
        @transforms << "PA#{size},#{xoff},#{yoff},#{fuzz}"
        self
      end
      
      ##
      # Add a border around the image. Takes the following arguments
      #
      # * +width+ - size of the border (pixels)
      # * +color+ - color of the border in HTML format (eg, "#CCCCCC") [defaults
      #   black if not specified]
      def add_border! (width, html_color="\#000000")
        color = Color::RGB.from_html(html_color)
        cmd = "BO#{width}," 
        cmd << [color.r, color.g, color.b].map {|c| (c*255).to_i }.join(",")
        @transforms << cmd
        self
      end
      
      ##
      # Rotate the image. Takes a single argument of degrees to rotate. Positive 
      # values rotate to the right, negative to the left.
      #
      # According to auugh: "The values seem to range as high as 135. Positive 
      # values rotate to the right, negative numbers rotate to the left. Negative
      # numbers go... well, I stopped testing in the hundreds of millions, but 
      # there's not much need to go beyond -360, which takes it full circle. 
      # Positive rotations in some values seem to cause severe image shrinkage, 
      # so you should consider using a size adjustment after rotation."
      def tilt! (degrees)
        @transforms << "PT#{degrees}"
        self
      end
      
      ##
      # Blur the image. The input argument seems to represent a radius, but the
      # essential thing to know is the higher the value, the blurrier it gets.
      def blur! (radius)
        @transforms << "BL#{radius}"
        self
      end
      
      ##
      # Sharpen the image. The value can range from 0 - 99. Larger values may
      # affect color and increase noise significantly.
      def sharpen! (percent)
        @transforms << "SH#{percent}"
        self
      end
      
      ##
      # Scale the image to exact dimensions. Takes a scaling type and dimension
      # in pixels. There are four types of scaling possible:
      #
      # * +:proportion+ - preserve the image's proportions
      # * +:square+ - make the image square
      # * +:width+ - the size represents the width of image. Height is 
      #   proportionally scaled.
      # * +:height+ - the size represents the height of the image. Width is 
      #   proportionally scaled.
      def scale!(type, size)
        @transforms << "#{SCALE_TYPES[type]}#{size}"
        self
      end
      
      ##
      # Crops the image. This can be used to generate Flickr-like square windows 
      # into the image (although there is no method to figure out programmatically
      # the dimensions of a particular size, so this might be hard [maybe scale
      # then crop?]). Takes four arguments to set the crop square:
      #
      # * +xoff+ - x offset from top left corner of image to tlc of box (pixels)
      # * +yoff+ - y offset from top left corner of image to tlc of (pixels)
      # * +width+ - width of crop square
      # * +height+ - height of crop square
      def crop! (xoff, yoff, width, height)
        @transforms << "CR#{xoff},#{yoff},#{width},#{height}"
        self
      end
      
      ##
      # Overlay text on the image. This is easily the most complicated transformation
      # you can apply in terms of sheer argument heft. The text is placed in a square
      # area you must set the dimensions of first. Takes the following options:
      #
      # * +text+ - the text you want to overlay
      # * +xoff+ - x offset from the top left corner to tlc of box (pixels)
      # * +yoff+ - y offset from the top left corner to tlc of box (pixels)
      # * +width+ - width of the text box
      # * +height+ - height of the text box in pixels
      # * +font+ - four options are allowed:
      #   * :times - Times Roman
      #   * :arial - Arial
      #   * :arialbi - Arial Bold Italic
      #   * :verdanab - Verdana Bold
      #   * :advc128d - barcode font
      # * +size+ - font size (points?)
      # * +color+ - a color specified in HTML style (eg, "#CCEECC")
      # * +align+ - may be :left or :center only, defaults to :left
      def add_text! (text, xoff, yoff, width, height, font, size, html_color, align=:left)
        color = Color::RGB.from_html(html_color)
        cmd = (align == :center) ? "ZC" : "ZA"
        parts = [URI.escape(text), xoff, yoff, width, height, font, size].map {|x| x.to_s} +
                [color.r, color.g, color.b].map {|c| (c*255).to_i }
        cmd << parts.join(",")
        @transforms << cmd
        self
      end
              
      ##
      # Highlight the image. I'm still not sure what this means, but here it is. 
      # You specify an square highlight area of the image with the following 
      # parameters:
      #
      # * +xoff+ - x offset from the top left corner to tlc of box (pixels)
      # * +yoff+ - y offset from the top left corner to tlc of box (pixels)
      # * +width+ - width of the text box
      # * +height+ - height of the text box in pixels
      # * +intensity+ - I really don't know what this means, but more is bigger
      def highlight!(xoff, yoff, width, height, intensity)
        @transforms << "HL#{xoff},#{yoff},#{width},#{height},#{intensity}"
        self
      end

      ##
      # Transformations like #crop! and #add_shadow!, etc. can be chained and
      # are potentially applied in the order specified. Should you need to clear
      # the transforms and revert to the original image, this command does that.
      def reset_transforms!
        @transforms = []
        self
      end
      
      ##
      # Returns a URL for the image from Amazon's servers.
      def url
        url = "http://#{country_imghost}/images/P/#{asin}"
        url << "." << country_imgcode << "."
    
        url << "_" << @transforms.join("_") << "_" << ".jpg"
      end
      
      ##
      # This method is an alias for #url
      alias :to_s :url
    end
  end
end
