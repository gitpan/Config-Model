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
    'name' => 'LCDd::SureElec',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/ttyUSB0',
        'type' => 'leaf',
        'description' => 'Port the device is connected to  (by default first USB serial port)'
      },
      'Edition',
      {
        'value_type' => 'uniline',
        'upstream_default' => '2',
        'type' => 'leaf',
        'description' => 'Edition level of the device (can be 1, 2 or 3) [default: 2]'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'default' => '16x2',
        'type' => 'leaf',
        'description' => 'set display size
Note: The size can be obtained directly from device for edition 2 & 3.'
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '480',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial contrast [default: 480; legal: 0 - 1000]'
      },
      'Brightness',
      {
        'value_type' => 'integer',
        'min' => '1',
        'upstream_default' => '480',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial brightness [default: 480; legal: 1 - 1000]'
      },
      'OffBrightness',
      {
        'value_type' => 'integer',
        'min' => '1',
        'upstream_default' => '100',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial off-brightness [default: 100; legal: 1 - 1000]
This value is used when the display is normally
switched off in case LCDd is inactive'
      }
    ]
  }
]
;
