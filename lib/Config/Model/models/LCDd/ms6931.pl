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
    'name' => 'LCDd::ms6931',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/ttyS1',
        'type' => 'leaf',
        'description' => 'device to use [default: /dev/ttyS1]'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '16x2',
        'type' => 'leaf',
        'description' => 'display size [default: 16x2]'
      }
    ]
  }
]
;
