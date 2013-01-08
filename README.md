remote_macro
============

Description
-----------

「リモートホストに対してTeraTermマクロ的な操作をあれこれやって、最後になんらかのファイルを落としてくる」

といった操作をよくやるので、テンプレート化した。

Features
--------


Usage
-----

```ruby
require 'remotemacro'

class DailyOperation < RemoteMacro::SSHOperation
  def excute_batch!
    shell do |sh|
      sh.excute! 'cd /tmp'
      sh.excute './batch.sh' do |_, output|
        unless output.chomp == 'Completed!'
          raise Error, "/tmp/batch.sh finished, but unexpected behavior\n#{output}"
        end
      end
      sh.excute! 'exit'
    end
  end
end

DailyOperation.run do
  excute_batch!
  download! '/tmp/batch.log'
end
```

Requirements
-------------

* Ruby - [1.9.3 or later](http://travis-ci.org/#!/kachick/remote_macro)

Install
-------

```bash
git clone https://github.com/kachick/remote_macro.git
gem build remote_macro.gemspec
gem install remote_macro
```

Build Status
-------------

[![Build Status](https://secure.travis-ci.org/kachick/remote_macro.png)](http://travis-ci.org/kachick/remote_macro)

Link
----

* [Home](http://kachick.github.com/remote_macro)
* [code](https://github.com/kachick/remote_macro)
* [API](http://kachick.github.com/remote_macro/yard/frames.html)
* [issues](https://github.com/kachick/remote_macro/issues)
* [CI](http://travis-ci.org/#!/kachick/remote_macro)
* [gem](https://rubygems.org/gems/remote_macro)

License
--------

The MIT X11 License  
Copyright (c) 2013 Kenichi Kamiya  
See MIT-LICENSE for further details.

