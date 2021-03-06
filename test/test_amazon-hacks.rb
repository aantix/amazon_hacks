# Code Generated by ZenTest v. 3.4.2
#                 classname: asrt / meth =  ratio%
#      Amazon::Hacks::Image:    0 /   15 =   0.00%
#       Amazon::Hacks::Link:    0 /    8 =   0.00%
#                 Countries:    0 /    3 =   0.00%

require 'test/unit' unless defined? $ZENTEST and $ZENTEST
require './lib/amazon-hacks'

module TestAmazon
  module TestHacks
    class TestCountries
      include Amazon::Hacks::Countries
      
      def setup
        @country = :uk
      end
      
      def test_country_host
        assert_equal("www.amazon.co.uk", country_host)
      end
      
      def test_country_imgcode
        assert_equal("02", country_imgcode)
      end
      
      def test_country_imghost
        assert_equal("images.amazon.co.uk", country_imghost)
      end
    end
  end
end

module TestAmazon
  module TestHacks
    class TestImage < Test::Unit::TestCase
      URL_PREFIX = "http://images.amazon.com/images/P/0201485672.01."
      
      def setup
        @img = Amazon::Hacks::Image.new("0201485672", :us)
      end
      
      def test_build_from_url
        i = Amazon::Hacks::Image.build_from_url("http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672/sr=8-1/qid=1165273301/ref=pd_bbs_sr_1/002-2410048-1716806?ie=UTF8&s=books")
        assert_equal("#{URL_PREFIX}__.jpg", i.url)
      end
      
      def test_build_from_url_invalid
        i = Amazon::Hacks::Image.build_from_url("http://www.yahoo.com")
        assert_equal(i, nil)
      end

      def test_add_border_bang
        @img.add_border! 12, "\#CC2244"
        assert_equal("#{URL_PREFIX}_BO12,204,34,68_.jpg", @img.url)
      end

      def test_add_custom_shadow_bang
        @img.add_custom_shadow! 2, 23, 45, 30
        assert_equal("#{URL_PREFIX}_PA2,23,45,30_.jpg", @img.url)
      end

      def test_add_shadow_bang_left
        @img.add_shadow! :left
        assert_equal("#{URL_PREFIX}_PB_.jpg", @img.url)
      end

      def test_add_shadow_bang_right
        @img.add_shadow! :right
        assert_equal("#{URL_PREFIX}_PC_.jpg", @img.url)
      end

      def test_blur_bang
        @img.blur! 23
        assert_equal("#{URL_PREFIX}_BL23_.jpg", @img.url)
      end

      def test_crop_bang
        @img.crop! 0, 10, 20, 20
        assert_equal("#{URL_PREFIX}_CR0,10,20,20_.jpg", @img.url)
      end

      def test_highlight_bang
        @img.highlight! 0, 10, 20, 15, 75
        assert_equal("#{URL_PREFIX}_HL0,10,20,15,75_.jpg", @img.url)
      end

      def test_reset_transforms_bang
        @img.add_border! 33, "\#CCCCCC"
        @img.blur! 23
        @img.add_shadow! :right
        @img.reset_transforms!
        
        assert_equal("#{URL_PREFIX}__.jpg", @img.url)
      end

      def test_scale_bang_proportion
        @img.scale! :proportion, 23
        assert_equal("#{URL_PREFIX}_AA23_.jpg", @img.url)
      end

      def test_scale_bang_square
        @img.scale! :square, 23
        assert_equal("#{URL_PREFIX}_SS23_.jpg", @img.url)
      end

      def test_scale_bang_width
        @img.scale! :width, 23
        assert_equal("#{URL_PREFIX}_SX23_.jpg", @img.url)
      end

      def test_scale_bang_height
        @img.scale! :height, 23
        assert_equal("#{URL_PREFIX}_SY23_.jpg", @img.url)
      end

      def test_set_size_bang_small
        @img.set_size! :small
        assert_equal("#{URL_PREFIX}_SCTZZZZZZZ_.jpg", @img.url)
      end

      def test_set_size_bang_medium
        @img.set_size! :medium
        assert_equal("#{URL_PREFIX}_SCMZZZZZZZ_.jpg", @img.url)
      end

      def test_set_size_bang_large
        @img.set_size! :large
        assert_equal("#{URL_PREFIX}_SCLZZZZZZZ_.jpg", @img.url)
      end
            
      def test_sharpen_bang
        @img.sharpen! 83
        assert_equal("#{URL_PREFIX}_SH83_.jpg", @img.url)
      end

      def test_add_text_bang
        @img.add_text! "hello world", 5, 15, 100, 100, :times, 20, "\#CC2244", :left
        assert_equal("#{URL_PREFIX}_ZAhello%20world,5,15,100,100,times,20,204,34,68_.jpg", @img.url)
      end

      def test_text_bang_center
        @img.add_text! "hello world", 5, 15, 100, 100, :times, 20, "\#CC2244", :center
        assert_equal("#{URL_PREFIX}_ZChello%20world,5,15,100,100,times,20,204,34,68_.jpg", @img.url)
      end
      
      def test_tilt_bang
        @img.tilt! 45
        assert_equal("#{URL_PREFIX}_PT45_.jpg", @img.url)
      end

      def test_url
        assert_equal("#{URL_PREFIX}__.jpg", @img.url)
        assert_equal("#{URL_PREFIX}__.jpg", @img.to_s)
      end
      
      def test_chain_transforms
        @img.set_size! :small
        @img.blur! 87
        @img.tilt! 23
        assert_equal("#{URL_PREFIX}_SCTZZZZZZZ_BL87_PT23_.jpg", @img.url)
      end
    end
  end
end

module TestAmazon
  module TestHacks
    class TestLink < Test::Unit::TestCase
      def setup
        @us_link = Amazon::Hacks::Link.new("http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672/sr=8-1/qid=1165273301/ref=pd_bbs_sr_1/002-2410048-1716806?ie=UTF8&s=books")
        @uk_link = Amazon::Hacks::Link.new("http://www.amazon.co.uk/The-IT-Crowd/dp/B000EU1OYC/sr=8-1/qid=1165274239/ref=pd_ka_1/026-4633332-4150855?ie=UTF8&s=dvd")      
      end
      
      def test_class_extract_asin_1
        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.com/o/asin/0201485672")
        assert_equal("0201485672", asin)

        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.co.uk/o/asin/B000EU1OYC")
        assert_equal("B000EU1OYC", asin)
      end
      
      def test_class_extract_asin_2
        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.com/exec/obidos/ASIN/0201485672")
        assert_equal("0201485672", asin)

        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.co.uk/exec/obidos/ASIN/B000EU1OYC")
        assert_equal("B000EU1OYC", asin)      
      end
      
      def test_class_extract_asin_3
        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.com/exec/obidos/tg/detail/-/0201485672")
        assert_equal("0201485672", asin)

        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.co.uk/exec/obidos/tg/detail/-/B000EU1OYC")
        assert_equal("B000EU1OYC", asin)      
      end
      
      def test_class_extract_asin_4
        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672/sr=8-1/qid=1165273301/ref=pd_bbs_sr_1/002-2410048-1716806?ie=UTF8&s=books")
        assert_equal("0201485672", asin)
        
        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.co.uk/The-IT-Crowd/dp/B000EU1OYC/sr=8-1/qid=1165274239/ref=pd_ka_1/026-4633332-4150855?ie=UTF8&s=dvd")
        assert_equal("B000EU1OYC", asin)
      end
      
      def test_class_extract_asin_5
        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.com/gp/product/B000UCJJH8/ref=s9_hps_gw_g79_ir05?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-7&pf_rd_r=0ARJFTRWT51HYMN26CYR&pf_rd_t=101&pf_rd_p=1327793782&pf_rd_i=507846")
        assert_equal("B000UCJJH8", asin)
        
        asin = Amazon::Hacks::Link.extract_asin("http://www.amazon.com/gp/product/039370713X/ref=s9_newr_gw_g14_ir02?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-5&pf_rd_r=06A96K4XT8G6M3AB332B&pf_rd_t=101&pf_rd_p=470939291&pf_rd_i=507846")
        assert_equal("039370713X", asin)        
      end
        
      def test_class_extract_country
        assert_equal(:us, Amazon::Hacks::Link.extract_country("http://www.amazon.com/foo"))
        assert_equal(:uk, Amazon::Hacks::Link.extract_country("http://www.amazon.co.uk/foo"))
        assert_equal(:de, Amazon::Hacks::Link.extract_country("http://www.amazon.de/foo"))
        assert_equal(:fr, Amazon::Hacks::Link.extract_country("http://www.amazon.fr/foo"))
        assert_equal(:jp, Amazon::Hacks::Link.extract_country("http://www.amazon.co.jp/foo"))
      end

      def test_asin
        assert_equal("0201485672", @us_link.asin)
        assert_equal("B000EU1OYC", @uk_link.asin)
      end

      def test_associate_url
        assert_equal("http://www.amazon.com/o/asin/0201485672/testassoc", @us_link.associate_url("testassoc"))
        assert_equal("http://www.amazon.co.uk/o/asin/B000EU1OYC/testassoc", @uk_link.associate_url("testassoc"))
      end

      def test_normalize
        assert_equal("http://www.amazon.com/o/asin/0201485672", @us_link.normalize)
      end
      
      def test_normalize_bang
        @us_link.normalize!
        assert_equal("http://www.amazon.com/o/asin/0201485672", @us_link.to_s)
      end
      
      def test_url_equals
        link = Amazon::Hacks::Link.new
        link.url = "http://www.amazon.co.uk/The-IT-Crowd/dp/B000EU1OYC/sr=8-1/qid=1165274239/ref=pd_ka_1/026-4633332-4150855?ie=UTF8&s=dvd"
        assert_equal("http://www.amazon.co.uk/The-IT-Crowd/dp/B000EU1OYC/sr=8-1/qid=1165274239/ref=pd_ka_1/026-4633332-4150855?ie=UTF8&s=dvd", link.to_s)
        assert_equal(:uk, link.country)
        assert_equal("B000EU1OYC", link.asin)
      end
    end    
  end
end

