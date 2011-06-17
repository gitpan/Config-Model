#
# This file is part of Config-Model
#
# This software is Copyright (c) 2011 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'name' => 'LCDd::tyan',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/lcd',
        'type' => 'leaf',
        'description' => 'Select the output device to use [default: /dev/lcd]'
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => '9600',
        'type' => 'leaf',
        'description' => 'Set the communication speed [default: 9600; legal: 4800, 9600]',
        'choice' => [
          '4800',
          '9600'
        ]
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '16x2',
        'type' => 'leaf',
        'description' => 'set display size [default: 16x2]'
      }
    ]
  }
]
;

