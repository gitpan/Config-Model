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
    'name' => 'LCDd::lb216',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/lcd',
        'type' => 'leaf',
        'description' => 'Select the output device to use [default: /dev/lcd]'
      },
      'Brightness',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '255',
        'max' => '255',
        'type' => 'leaf',
        'description' => 'Set the initial brightness [default: 255; legal: 0 - 255]'
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => '9600',
        'type' => 'leaf',
        'description' => 'Set the communication speed [default: 9600; legal: 2400, 9600]',
        'choice' => [
          '2400',
          '9600'
        ]
      },
      'Reboot',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Reinitialize the LCD\'s BIOS [default: no; legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      }
    ]
  }
]
;

