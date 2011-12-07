== This is a fork of the "Amazon Hacks" gem since the original appears to be abandoned.

At this time, I have just updated the logic surrounding deriving an image URL from a product URL.  I've kept the original README contents intact below. 

Feel free to fork and send a pull request if you wish to make other updates.

To reference this fork in your project, list it in your Gemfile as such :

    gem 'amazon-hacks', :git => 'git@github.com:aantix/amazon_hacks.git'

== ORIGINAL README

AmazonHacks
    by Jacob Harris
    harrisj@schizopolis.net
    Blog: http://www.nimblecode.com/
    NYC.rb: http://www.nycruby.org/

== DESCRIPTION:

Mainly the product of messing around, this gem comprises Ruby code for a few
useful "Amazon Hacks" -- common techniques for manipulating Amazon product URLs
and Images. This is mainly useful if you find yourself creating a site where you
might link to Amazon product pages and display images for them. Examples of this
might include:

* Social consumption sites like {All Consuming}[http://www.allconsuming.net/]
* Blogs or tumbleblogs with book/music/etc. reviews 
* Normalizing Amazon links or create associate IDs

This GEM is NOT related to using the Amazon Web Services and there is already an
excellent gem for that if you need more heavy-duty use of the Amazon website
(this gem does not even communicate with Amazon at all). Also, note this gem is
meant in the spirit of fun hackery. You can use it to create interesting images
from Amazon on demand, but if you are going to use it on a serious website,
please consider caching and attributing that image to Amazon (I also have no
idea what the official legal policy for using Amazon's book images is).

And of course, do not even consider using this for fraud. It is possible to
generate "20% off" or "Look Inside!" badges on Amazon images, but this gem does
not support that since I can not think of any reason why outside sites would use
that.

== FEATURES/PROBLEMS:

There are two main classes within the Amazon::Hacks namespace with the following
functionality:

=== Link (product URL)

* Extract country of site
* Extract ASIN (Amazon identifier)
* Normalize (reduce to most basic URL for matching)
* Associate URL (create a normalized URL with your Amazon Associate ID)
	
=== Image

- Derive a corresponding image URL from a product URL
- Sizes (small, medium, large)
- Shadow
- Border
- Crop
- Scale
- Tilt
- Blur
- Sharpen
- Highlight
- Text overlay

This is still a work in development, and while I have tested against some
generic Amazon rules, it is possible that certain countries might deviate from
Amazon's practices (for instance, China seems to not use the image generation
code and instead just links to static URLs). Let me know if you find any issues
for a given product link/image. Thank you.

== SYNOPSIS:

To use, simply +require 'amazon_hacks'+

=== LINKS

This gem is inspired by the {Abusing Amazon Images}[http://aaugh.com/imageabuse.html] page.

== REQUIREMENTS:

* Requires the 'color-tools' gem

== INSTALL:

* sudo gem install amazon-hacks

== LICENSE:

(The MIT License)

Copyright (c) 2006 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
