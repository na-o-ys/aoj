# AOJ

is a subimtter program which submits your source to [AOJ(Aizu Online Judge)](http://judge.u-aizu.ac.jp/onlinejudge/) and retrieves result of judgement. 
This program is forked from aizuzia's [AOJToolkit](http://d.hatena.ne.jp/Tayama/20101207/1291727425). 

## Installation

We've not deployed to RubyGems.org yet because this is unstable version for now.

You can install manually by following commands: 
```
$ git clone git://github.com/na-o-sss/aoj.git
$ rake build
$ rake install
```
or chose easier way with any tools like [specific\_install](https://github.com/rdp/specific_install).

## Configuration
You have to specify your login information. Edit `.aoj` and then put it in your home directory `~/.aoj`.
Configurations about twitter are not necessary as long as you don't use twitter funcionality.

## Usage

Submit simply:
```
$ aoj-submit 0001.cpp
```
or submit to Gist at the same time:
```
$ aoj-submit -g 0001.cpp
```
or post to Gist and Twitter at the same time:
```
$ aoj-submit -gt 0001.cpp
```

## Contributing

1. Fork it ( http://github.com/na-o-sss/aoj/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
