# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/amazon-hacks'

Hoe.new('amazon-hacks', AmazonHacks::VERSION) do |p|
  p.rubyforge_name = 'amazon-hacks'
  p.summary = 'A collection of useful snippets against the Amazon website'
  p.author = 'Jacob Harris'
  p.email = 'harrisj@schizopolis.net'
  p.url = 'http://www.nimblecode.com/code/AmazonHacks'
  p.description = p.paragraphs_of('README.rdoc', 2..6).join("\n\n")
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.extra_deps << ['color-tools', '>= 1.3.0']
end
