# AOJ

AOJ is a command-line tool for [AOJ(Aizu Online Judge)](http://judge.u-aizu.ac.jp/onlinejudge/). You can submit your source to AOJ and check the result of judgement without opening browser or copy & paste.

This program is forked from aizuzia's [AOJToolkit](http://d.hatena.ne.jp/Tayama/20101207/1291727425). 

## Installation

Please make sure that Ruby (version 2.0 or later) is installed.

You can install AOJ via RubyGems.org
```
$ gem install aoj
```

## Usage

Problem ID and Language are auto-detected by filename. You should make your source file be like `[ProblemID].(cpp|rb|...)`.

#### Submit simply

```
$ aoj submit 0001.cpp
```

#### Problem ID and Language can be manually specified

```
$ aoj submit mysource.cpp -p 0001 -l cpp11
```

#### Tweet result (only when accepted)

```
$ aoj submit 0001.cpp -t
```

#### List available languages

```
$ aoj lang
List available languages:
  c, cpp, java, cpp11, csharp, d, ruby, python, python3, php, js

Auto-detect extensions:
  [ext]     [lang]
  .c        c
  .cpp      cpp
  .cc       cpp
  .C        cpp
  .java     java
  .rb       ruby
  .cs       csharp
  .d        d
  .py       python
  .php      php
  .js       javascript
```

You can check all other commands and options by typing `aoj` and enter.

## Configuration

AOJ supports interactive configuration. Your account information once used will be stored at your home directory `~/.aojrc`.

If you need to use an HTTP proxy to access the Internet, export the HTTP_PROXY or http_proxy environment variable: `export $HTTP_PROXY="http://user:password@proxy:8080"`.

AOJ also support some extra configurations.

#### Custom mapping from file extension to language

To use custom mapping, please edit `~/.aojrc` directly.

For example:

```
extname:
  ".py": python3
  ".cpp": cpp11
```

which means, `hoge.py` file will be submitted as Python3 and `hoge.cpp` is C++11.

## Contributing

1. Fork it ( http://github.com/na-o-ys/aoj/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
