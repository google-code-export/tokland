#!/usr/bin/python
import glob
import os
import re

import dictdlib

def generate_dict_files(inputdir, outputbase):
  d = dictdlib.DictDB(outputbase, "write")
  for path in glob.glob(os.path.join(inputdir, "*.html")):
      word = os.path.basename(path).replace('.html', '')
      html = open(path).read()
      definition = re.sub(r'<[^>]*?>', '', html).strip()    
      d.addentry(definition, [word])
  d.finish()
  
generate_dict_files("drae2.2", "drae")  
