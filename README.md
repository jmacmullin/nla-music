Copyright © 2012 Jake MacMullin

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


nla-music
=========

An iPad app to explore the National Library's digital collection of sheet music.


Dependencies
============

This app uses [Nimbus](http://nimbuskit.info) which in turn uses AFNetworking and 
JSONKit (though as this app is iOS6 only, JSONKit isn't actually used at runtime).

Before you can complie and run this app, you'll need to make sure you've got all of
these dependencies. They've been added to this project as git submodules, so be sure
to use the --recursive option when you clone this project to make sure you also get
all the submodules:

git clone --recursive https://github.com/jmacmullin/nla-music.git
