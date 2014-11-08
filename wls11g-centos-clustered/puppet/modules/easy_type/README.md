[![Code Climate](https://codeclimate.com/github/hajee/easy_type.png)](https://codeclimate.com/github/hajee/easy_type) [![Build Status](https://travis-ci.org/hajee/easy_type.png)](https://travis-ci.org/hajee/easy_type) [![Dependency Status](https://gemnasium.com/hajee/easy_type.png)](https://gemnasium.com/hajee/easy_type) [![Coverage Status](https://coveralls.io/repos/hajee/easy_type/badge.png)](https://coveralls.io/r/hajee/easy_type) [![Inline docs](http://inch-ci.org/github/hajee/easy_type.png)](http://inch-ci.org/github/hajee/easy_type)

#easy_type

Robert scratched his head. How would he get a Puppet class to manage a complex resource on his systems? I guess I’ll have to make a Custom Type, he thought. But last time I looked into that, I noticed you need to know a lot about Puppet Internals. 

If you recognize this thought process, easy_type is for you. Like the name says, easy type is designed to make it easy to build a Custom Puppet Type. 

##Tutorial
Check [this blog post](http://hajee.github.io/2014/01/26/puppet-custom-types-the-easy-way/) for a tutorial on using `easy_type`.

##Documentation
Check the [rdoc](http://rubydoc.info/github/hajee/easy_type/master/frames) documentation for easy_type

##Get Started
To get started, you first need to install the `easy_type` module.

```
$ puppet module install hajee/easy_type
```
Custom types need to be part of a module. So we need to have a module. You can create a module with the `puppet module tool`
```
$ puppet module generate robert/test_module
```


#Creating a scaffold of your type

You can use `easy_type` to create your custom type scaffold.

```sh
$ cd robert-test_module
$ puppet type scaffold my_type
```
#Add a property
A custom type without a property is not very useful. So we need to create a property:

```sh
$ puppet type generate property my_property my_type
```

#Edit your custom type

You can edit the code in `lib/puppet/types/my_type.rb` and the ruby files in `lib/puppet/types/my_type/`

Spread the word
---------------
If you like easy_type, You can spread the word by adding a badge to the README.md file of your newly created type.

```
[![Powered By EasyType](https://raw.github.com/hajee/easy_type/master/powered_by_easy_type.png)](https://github.com/hajee/easy_type)
```

This will look like this:

[![Powered By EasyType](https://raw.github.com/hajee/easy_type/master/powered_by_easy_type.png)](https://github.com/hajee/easy_type)

License
-------
MIT License

Contact
-------
Bert Hajee hajee@moretIA.com

Support
-------
Please log tickets and issues at our [Projects site](https://github.com/hajee/easy_type)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/hajee/easy_type/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

