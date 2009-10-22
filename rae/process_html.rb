#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'

def process_html(indir, outdir)
  FileUtils.mkdir_p(outdir)
  Dir.glob(File.join(indir, "*.html")).sort.each do |path|
    doc = Nokogiri::HTML(open(path))  
    unless contents = doc.search("div#definicion div:last").first
      STDERR.write("Definition not found: #{path}\n")
      next
    end
    contents.search("a").each do |a|
      if a.attributes["href"].to_s =~ /origen=RAE&LEMA=(.*?)&/
        a.set_attribute("href", $1+".html") 
      end
    end
    output_path = File.join(outdir, File.basename(path))
    open(output_path, "w") { |f| f.write(contents.to_s) }
  end
end

process_html("html", "html2")
