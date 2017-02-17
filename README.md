# megadecrypter

This app decrypts `mega://enc2` links passed as an argument

## Requirements
- [Crystal](https://crystal-lang.org)

## Installation

1. `git clone https://github.com/denysvitali/megadecrypter/`
2. `cd megadecrypter`
3. `crystal build --release src/megadecrypter.cr`

If you want to install it permanently:
1. `sudo mv ./megadecrypter /usr/bin/`
2. `sudo chmod 755 /usr/bin/megadecrypter; sudo chown root:root /usr/bin/megadecrypter`

If you want to run it just once:

1. `./megadecrypter`

## Usage

`megadecrypter "mega://enc2?encryptedString"`

## Contributing

1. Fork it ( https://github.com/denysvitali/megadecrypter/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [denysvitali](https://github.com/denysvitali) Denys Vitali - creator, maintainer
