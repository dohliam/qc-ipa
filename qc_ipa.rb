#!/usr/bin/ruby -KuU
# encoding: utf-8

require 'optparse'

def normalize_qc(ipa)
  raw_ipa = ipa.chomp.gsub(/\//, "")
  raw_ipa.gsub(/ɛl$/, "al")
  .gsub(/ti/, "t͡si")
  .gsub(/ty/, "t͡sy")
  .gsub(/di/, "d͡zi")
  .gsub(/dy/, "d͡zy")
  .gsub(/dj/, "d͡zj")
  .gsub(/tj/, "t͡sj")
  .gsub(/bl$/, "b")
  .gsub(/bʁ$/, "b")
  .gsub(/dʁ$/, "d")
  .gsub(/fl$/, "f")
  .gsub(/gm$/, "g")
  .gsub(/gʁ$/, "g")
  .gsub(/kʁ$/, "k")
  .gsub(/([^s])kl$/, "\\1k")
  .gsub(/kst$/, "ks")
  .gsub(/kt$/, "k")
  .gsub(/mn$/, "m")
  .gsub(/pt$/, "p")
  .gsub(/sk$/, "s")
  .gsub(/skl$/, "s")
  .gsub(/sm$/, "s")
  .gsub(/st$/, "s")
  .gsub(/stʁ$/, "s")
  .gsub(/tm$/, "t")
  .gsub(/tʁ$/, "t")
  .gsub(/vʁ$/, "v")
  .gsub(/ɛ̃/, "ẽĩ̯")
  .gsub(/ɔ̃/, "õũ̯")
  .gsub(/œ̃/, "œ̃˞")
  .gsub(/ɔ/, "ɑɔ̯")
  .gsub(/([^w])a$/, "\\1ɔ")
  .gsub(/ɛ/, "a")
  .gsub(/ɑ̃$/, "æ̃") # imprecise: only in open final syllables
  .gsub(/ɑ̃(.)$/, "ãũ̯\\1") # imprecise: only in closed final syllables
  .gsub(/ɑː/, "ɑʊ̯")
  .gsub(/ɛː/, "aɪ̯")
#   ɛ̃ː => ?
#   ɑ̃ː => ?
#   .gsub(/skl$/, "s / sk")
end

def affricate(ipa)
  while ipa.match(/([abdfgɡhjklmnpʁsʃtvwz])i([abdfgɡhjklmnpʁsʃtvwz])/)
    ipa.gsub!(/([abdfgɡhjklmnpʁsʃtvwz])i([abdfgɡhjklmnpʁsʃtvwz])/, "\\1ɪ\\2")
  end
  while ipa.match(/([abdfgɡhjklmnpʁsʃtvwz])y([abdfgɡhjklmnpʁsʃtvwz])/)
    ipa.gsub!(/([abdfgɡhjklmnpʁsʃtvwz])y([abdfgɡhjklmnpʁsʃtvwz])/, "\\1ʏ\\2")
  end
  while ipa.match(/([abdfgɡhjklmnpʁsʃtvwz])u([abdfgɡhjklmnpʁsʃtvwz])/)
    ipa.gsub!(/([abdfgɡhjklmnpʁsʃtvwz])u([abdfgɡhjklmnpʁsʃtvwz])/, "\\1ʊ\\2")
  end
  ipa
end

def manual_convert(word)
  conversions = File.read("conversions.txt")
  found = false
  conversions.each_line do |line|
    headword, ipa = line.chomp.split("\t")
    if headword == word
      found = true
      puts line
    end
  end
  found
end

def process_dict(fr)
  fr.each_line do |line|
    word,ipa = line.split("\t")
    found = manual_convert(word)
    if !found
      ipa_split = ipa.split(", ")
      collector = []
      ipa_split.each do |i|
        qc = normalize_qc(ipa)
        qc = affricate(qc)
        collector << qc
      end
      puts word + "\t/" + collector.join("/, /") + "/"
    end
  end
end

def check_word(word, dict)
  db = File.read(dict)
  found = false
  db.each_line do |line|
    headword, ipa = line.chomp.split("\t")
    if headword == word
      found = true
      puts line
    end
  end
  if found == false
    abort("  Entry \"#{word}\" not found in dictionary file.")
  end
end

def lookup_word(word, dict)
  found = false
  vocab = File.read("mots.txt")
  vocab.each_line do |line|
    headword, ipa = line.chomp.split("\t")
    if headword == word
      found = true
      puts line
    end
  end
  if found == false
    found = manual_convert(word)
  end
  if found == false
    db = File.read(dict)
    db.each_line do |line|
      headword, ipa = line.chomp.split("\t")
      if headword == word
        found = true
        qc = normalize_qc(ipa)
        qc = affricate(qc)
        puts word + "\t/" + qc + "/"
      end
    end
  end
  if found == false
    abort("  Entry \"#{word}\" not found.")
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: qc_ipa.rb [options]"

  opts.on('-c', '--check WORD', 'Check if word exists in standard French database (dictionary file must be specified with -d)') { |v| options[:check_word] = v }
  opts.on('-d', '--dictionary FILE', 'Specify Standard French IPA dictionary file') { |v| options[:dictionary_file] = v }
  opts.on('-i', '--ipa-convert IPA', 'Convert single word IPA') { |v| options[:ipa_convert] = v }
  opts.on('-l', '--lookup WORD', 'Lookup / convert a single word (dictionary file must be specified with -d)') { |v| options[:lookup_word] = v }
  opts.on('-p', '--process [DICTIONARY]', 'Convert entire IPA dictionary file') do |v|
    options[:process_dict] = true
    options[:dict] = v || ''
  end

end.parse!

if options[:check_word]
  word = options[:check_word]
  if options[:dictionary_file]
    dict = options[:dictionary_file]
    check_word(word, dict)
  else
    abort("  Please specify a dictionary file.")
  end
  exit
end

if options[:lookup_word]
  word = options[:lookup_word]
  if options[:dictionary_file]
    dict = options[:dictionary_file]
    lookup_word(word, dict)
  else
    abort("  Please specify a dictionary file.")
  end
  exit
end

if options[:ipa_convert]
  ipa = options[:ipa_convert]
  qc = normalize_qc(ipa)
  qc = affricate(qc)
  puts qc
  exit
end

if options[:process_dict]
  dict = options[:dict]
  if dict == ""
    if options[:dictionary_file]
      dict = options[:dictionary_file]
    else
      abort("  Please specify a dictionary file.")
    end
  end
  process_dict(File.read(dict))
  exit
end
