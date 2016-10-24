#!/usr/bin/python

import sys

from HTMLParser import HTMLParser

allrest=[]

class restaurant: 

  def afegir_nom(self,nom):
    self.nom = nom

  def afegir_addr(self,addr):
    self.addr = addr

  def afegir_lat(self,lat):
    self.lat = lat
    
  def afegir_lon(self,lon):
    self.lon = lon


# creem una subclasse i sobreescribim el metodes del han
class MHTMLParser(HTMLParser):

  crest = restaurant()
  ctag = ""

  def handle_starttag(self, tag, attrs):
    self.ctag = tag
    if tag == 'v:vcard':
      self.crest = restaurant()

  def handle_endtag(self, tag):
    self.ctag = ""
    if tag == 'v:vcard':
      allrest.append(self.crest)

  def handle_data(self, data):
    if self.ctag == 'v:fn':
      self.crest.afegir_nom(data)

    if self.ctag == 'v:street-address':
      self.crest.afegir_addr(data)
      
    if self.ctag == 'v:latitude':
      self.crest.afegir_lat(data)
      
    if self.ctag == 'v:longitude':
      self.crest.afegir_lon(data)
    




f = open('restaurants.rdf', 'rb') # obre l'arxiu
rdfSource = f.read()                            
f.close()

parser = MHTMLParser()
parser.feed(rdfSource)
print len(allrest)
for r in allrest:
  print r.nom
  if(hasattr(r,'addr')):
    print r.addr
  if(hasattr(r,'lat')):
    print r.lat
  if(hasattr(r,'lon')):
    print r.lon

