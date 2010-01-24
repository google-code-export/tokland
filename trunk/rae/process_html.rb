#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'

def process_html(data)
  doc = Nokogiri::HTML(data)
  divs = doc.search("div#definicion div")
  if divs.empty?
    STDERR.write("html does not contain definition: #{path}\n")
    return
  end
  divs[1..-1].map do |contents|
    contents.search("a").each do |a|
      if a.attributes["href"].to_s =~ /origen=RAE&LEMA=(.*?)&/
        a.set_attribute("href", $1+".html") 
      end
    end
    contents.inner_html
  end.join
end

def process_html_dir(indir, outdir)
  FileUtils.mkdir_p(outdir)
  Dir.glob(File.join(indir, "*.html")).sort.map do |path|
    outdata = process_html(open(path))
    output_path = File.join(outdir, File.basename(path))
    open(output_path, "w") { |f| f.write(outdata) }
    output_path
  end.size
end

process_html("html", "drae2.2")
