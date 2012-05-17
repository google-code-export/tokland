#!/usr/bin/ruby
# encoding: utf-8
require 'rubygems'
require 'fileutils'
require 'nokogiri'
require 'facets'
require 'erubis'
require "unicode_utils"
require 'active_support/core_ext/object'

module ProcessHtml
  def self.run(path_patterns, output_dir, template)
    # definitions with different ID belongs to the same word, group them.
    definition_by_word = Dir.glob(path_patterns).sort.map_by do |path|
      doc = Nokogiri::HTML(open(path))
      word_el = doc.at_css("div p span.eLema b") or next
      word = word_el.text.presence or fail("word not found: #{path}")
      index = doc.at_css("div p span.eLema b sup").try(:text) || 1
      ps = doc.css("div p").reject { |para| para["style"] =~ /color: red/ }
      
      # fix links
      ps.each do |para|
        para.css("a").each do |a|
          href = a.attributes["href"].to_s
          if href.match(/SrvltGUIVerbos/)
            a.remove() 
          elsif (match = href.match(/origen=RAE&LEMA=(.*?)&/))
            a.set_attribute("href", match[1] + ".html") 
          end
        end
      end
      
      contents = ps.map(&:to_s).join
      $stderr.puts "#{path}: #{word}-#{index}"
      [UnicodeUtils.downcase(word), [index, contents]]
    end

    FileUtils.mkdir_p(output_dir)
    definition_by_word.each do |word, definitions_indexed|
      next unless word
      path = File.join(output_dir, "#{word}.html")
      definitions = definitions_indexed.sort.map(&:last).join("<hr />")
      namespace = {:word => word, :definitions => definitions}
      html = Erubis::Eruby.new(template).result(namespace)
      open(path, "w") { |f| f.write(html) }
      $stderr.puts "#{word}: #{path}"
    end
  end
end

template =<<-EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">
<head>
  <title>RAE - Diccionario de la Lengua Española: <%= word %></title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
  <%= definitions %>
</body>
</html>
EOF

ProcessHtml.run(ARGV[0] || "html/*.html", "html-defs", template)
