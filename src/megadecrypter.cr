require "./megadecrypter/*"
require "openssl/cipher"
require "base64"

module Megadecrypter
  class Crypto
    @enc_xor = [12, 0x39, 0xfb, 120, 0x12, 0x4b, 6, 250, 0x55]
    @pwd2 : Bytes

    def initialize()
      @pwd2 = UInt8.slice(110, 89, 114, 88, 97, 64, 57, 81, 63, 49, 38, 104, 67, 87, 77, 92, 57, 40, 55, 51, 49, 66, 112, 63, 116, 52, 50, 61, 33, 107, 51, 46);
    end

    def getBytes
      byteDecKey = @pwd2
      maxBK = byteDecKey.size - 1

      0.upto(159) do |i|
        byteDecKey[i % 32] = byteDecKey[i % 32] ^ @enc_xor[i % 9]
      end
      slice = Slice(UInt8).new(32)
      0.upto(maxBK) do |i|
        slice[i] = byteDecKey[i]
      end
      slice
    end

    def decrypt(string)
      string = Base64.decode(cleanString(string))
      key = getBytes()
      iv = UInt8.slice(0x79, 0xf1, 10, 1, 0x84, 0x4a, 11, 0x27, 0xff, 0x5b, 0x2d, 0x4e, 14, 0xd3, 0x16, 0x3e)

      ciphertext = string.to_slice
      cipher = OpenSSL::Cipher.new("AES-256-CBC")
      buffer4 = string.to_slice
      cipher.decrypt
      cipher.iv = iv
      cipher.key = key
      s1 = IO::Memory.new
      s1.write(cipher.update(buffer4))
      s1.write(cipher.final)
      s1 = s1.to_s
      s1 = s1.gsub("+", "-")
           .gsub("/", "_")
           .gsub("=", "")
      s1
    end

    def encrypt(string)
      string = Base64.encode(dirtyString(string))
    end

    def cleanString(string)
      string = string
        .gsub("-","+")
        .gsub("_", "/")
        .gsub(",", "")
      string + "=="
    end

    def dirtyString(string)
      string = string
        .gsub("+","-")
        .gsub("/","_")
      string
    end
  end

  def self.encryptLink(string)
    mdata = string.match(/^https:\/\/mega\.nz\/#\![A-z0-9]{8}\![A-z0-9_-]{40,}/i)
    
      
  end

  def self.decryptLink(string)
    # mega://enc2?lsV5qNM_0Mfq0DlWxCPvJdD...
    mdata = string.match(/^mega:\/\/(f|)enc2\?(.*)$/i)
    if mdata
      folder = mdata[1] == "f"
      dec = Crypto.new.decrypt(mdata[2])
      md2 = dec.match(/^(.*?)\!(.*)$/)
      if md2
        if folder
          puts "https://mega.nz/#F#{dec}"
        else
          puts "https://mega.nz/##{dec}"
        end
      end
    else
      puts "Invalid mega encrypted link"
    end
  end

  def self.printHelp()
    puts "Decrypt: megadecrypter 'mega://enc2?encryptedString'"
    puts "Encrypt: megadecrypter 'https://mega.nz/#!YjAD1ITK!vUnvsJhkhD6R01YllROk5DqKwHc6mr2VHSbiacQX7c8'"
  end

  if ARGV.size < 1
    self.printHelp()
    exit
  end

  if(ARGV[0].match(/^https:\/\/mega\.nz\//i))
    puts "Encrypt..."
    self.encryptLink(ARGV[0])
  elsif(ARGV[0].match(/^mega:\/\/(f|)enc2\?(.*)$/i))
    puts "Decrypt..."
    self.decryptLink(ARGV[0])
  else
    STDERR.puts "Unable to encrypt / decrpyt the provided link"
  end
  #self.decryptLink(ARGV[0])
end
