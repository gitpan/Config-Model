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
    'name' => 'LCDd::mx5000',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/hiddev0',
        'type' => 'leaf',
        'description' => 'Select the output device to use [default: /dev/hiddev0]'
      },
      'WaitAfterRefresh',
      {
        'value_type' => 'uniline',
        'upstream_default' => '1000',
        'type' => 'leaf',
        'description' => 'Time to wait in ms after the refresh screen has been sent [default: 1000]'
      }
    ]
  }
]
;
