# yamlfile #

yamlfile module with yaml_setting type+provider, a la Chris Price’ inifile
module / ini_setting type+provider

This is an experimental utility module allowing for more dynamic configuration
of the myriad of yaml files used to configure various yaml-configured ruby
applications with finer grained control than templates would easily allow.

A rapid prototype provider is included built using Adrien Thebo’s
[filemapper](https://github.com/adrienthebo/puppet-filemapper) utility module.
It won’t account for comments but it mostly works.

## Usage ##

The type interface is probably the hardest part and is largely a design
question. The prototype says screw it, K.I.S.S., and assumes hashes are the
most common thing to be dealing with for yaml configuration files. As such a
pair of resources given as:

<pre>
yaml_setting { 'example1_1':
  target => '/tmp/example1.yaml',
  key    => 'value/subkey/final',
  value  => ['one', 'two', 'three'],
}
yaml_setting { 'example1_2':
  target => '/tmp/example1.yaml',
  key    => 'value/subkey/other':
  value  => 'string',
}
</pre>

should result in a file e.g. `/tmp/example1.yaml`:

<pre>
value:
  subkey:
    final:
      - one
      - two
      - three
    other: string
</pre>

## Known Issues ##

Right now the type design doesn't allow for ruby symbols to be used as keys.

There are no tests.
