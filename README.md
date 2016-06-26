# xtor - Password Manager in JS
Encrypt / Decrypt in pure client-side JavaScript
- Uses AES-256-CBC with sha256 HMAC
- Salt generation using PBKDF2 with 32 byte key length
- Data always stays in the browser (never sent anywhere)
- Open Source MIT License

## [Live link](https://rajasharan.github.io/xtor)

## Screencase demo
![](/demo.gif)

## Local server setup
### Upgrage node
```sh
# upgrade node version >= 6.2.2
$ npm i -g npm
$ npm i -g n
$ sudo n 6.2.2
```

### Setup browserify
```sh
# browserify crypto file
$ npm i -g browserify
$ browserify cry.js -o X.js
```

### Setup elm
```sh
# compile elm packages
$ npm i -g elm
$ elm-package install
$ elm-make Main.elm --output elm.js
```

### Start server
```sh
# any static server will work
$ npm i -g lite-server
$ lite-server
```

### [License](/LICENSE)
The MIT License (MIT)
