require "openssl"
require "base64"

class Request
  def initialize(verb:, uri:, headers:, body:)
    @verb = verb
    @uri = uri
    @headers = headers
    @body = body
  end

  def headers
    @headers.map do |key, value|
      "#{key}: #{value}"
    end.join("\n")
  end

  private def verb
    @verb.upcase
  end

  private def uri
    @uri
  end

  private def body
    Base64.encode64(@body)
  end

  def to_s
    "#{verb} #{uri} #{headers} #{body}"
  end
end

class Signer
  def initialize(request:, algorithm:, secret:)
    @request = request
    @algorithm = algorithm
    @secret = secret
  end

  def algorithm
    @algorithm
  end

  def to_s
    Base64.encode64(digest)
  end

  private def digest
    OpenSSL.const_get(digester).digest(sha, @secret, @request.to_s)
  end

  private def digester
    algorithm.split("-").first.upcase
  end

  private def sha
    algorithm.split("-").last
  end
end

class Signature
  HEADER = "Signature"

  def initialize(key:, headers:, signer:)
    @key = key
    @headers = headers
    @signer = signer
  end

  def to_s
    "key=#{key} algorithm=#{algorithm} headers=#{headers} token=#{token}"
  end

  def to_h
    {
      HEADER => to_s
    }
  end

  private def key
    @key
  end

  private def algorithm
    @signer.algorithm
  end

  private def headers
    @headers.join(",")
  end

  private def token
    @signer.to_s
  end
end

class Builder
  def initialize(verb:, uri:, headers:, body:, algorithm:, key:, secret:)
    @request = Request.new(verb: verb, uri: uri, headers: headers, body: body)
    @signer = Signer.new(request: @request, secret: secret, algorithm: algorithm)
    @signature = Signature.new(key: key, headers: headers.keys, signer: @signer)
  end

  def ==(string)
    to_h["Signature"] == string
  end

  def to_h
    @signature.to_h
  end
end

verb = "GET"
uri = "http://google.com?a=1&b=2"
timestamp = Time.now
headers = {
  "Date" => timestamp.to_s,
  "Content-Type" => "application/vnd.blankapi+json; version=1.0.0",
  "Accept" => "application/vnd.blankapi+json; version=1.0.0, application/json"
}
body = ""
secret = "foozlebufzzle"
algorithm = "hmac-sha512"
key = "krainboltgreene"

builder = Builder.new(verb: verb, uri: uri, headers: headers, body: body, algorithm: algorithm, key: key, secret: secret)

p builder.to_h
