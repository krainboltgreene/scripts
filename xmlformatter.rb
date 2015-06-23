def paths
  Dir["**/*.xml"]
end

def files
  paths.map(&method(:file))
end

def file(path)
  [
    path,
    File.read(path).
      encode("UTF-8", invalid: :replace, replace: '').
      gsub(/\uFEFF/, "").
      strip
  ]
end

def documents
  files.map(&method(:document))
end

def document(pair)
  [
    pair.first,
    Nokogiri::XML(pair.last) do |config|
      config.options = Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::STRICT
    end
  ]
end

def xmls
  documents.map(&method(:xml))
end

def xml(pair)
  [pair.first, pair.last.to_xml(indent: 2)]
end

def writes
  xmls.map(&method(:write))
end

def write(pair)
  File.open(pair.first, "w") do |file|
    file.write(pair.last)
  end
end
