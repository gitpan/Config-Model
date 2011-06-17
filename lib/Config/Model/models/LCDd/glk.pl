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
    'name' => 'LCDd::glk',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/lcd',
        'type' => 'leaf',
        'description' => 'select the serial device to use [default: /dev/lcd]'
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '560',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'set the initial contrast value [default: 560; legal: 0 - 1000]'
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => '19200',
        'type' => 'leaf',
        'description' => 'set the serial port speed [default: 19200; legal: 9600, 19200, 38400]',
        'choice' => [
          '9600',
          '19200',
          '38400'
        ]
      }
    ]
  }
]
;

