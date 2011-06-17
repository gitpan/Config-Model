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
    'name' => 'LCDd::imon',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/lcd0',
        'type' => 'leaf',
        'description' => 'select the device to use'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'default' => '16x2',
        'type' => 'leaf',
        'description' => 'display dimensions'
      }
    ]
  }
]
;

