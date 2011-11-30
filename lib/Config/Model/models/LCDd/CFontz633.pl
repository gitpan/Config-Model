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
    'name' => 'LCDd::CFontz633',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/ttyS0',
        'type' => 'leaf',
        'description' => 'Note: Use of this driver is deprecated, please use CFontzPacket driver
with Model=633 instead.
Select the output device to use [default: /dev/lcd]'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '16x2',
        'type' => 'leaf',
        'description' => 'Select the LCD type (size) [default: 16x2]'
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '560',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial contrast [default: 560; legal: 0 - 1000]'
      },
      'Brightness',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '1000',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial brightness [default: 1000; legal: 0 - 1000]'
      },
      'OffBrightness',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '0',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial off-brightness [default: 0; legal: 0 - 1000]
This value is used when the display is normally
switched off in case LCDd is inactive'
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => '9600',
        'type' => 'leaf',
        'description' => 'Set the communication speed [default: 9600; legal: 1200, 2400, 9600, 19200, 115200]',
        'choice' => [
          '1200',
          '2400',
          '9600',
          '19200',
          '115200'
        ]
      },
      'NewFirmware',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Set the firmware version (New means >= 2.0) [default: no; legal: yes, no]
Currently this flag is not in use, there is no such thing as NewFirmware. ;=)',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'Reboot',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Reinitialize the LCD\'s BIOS [default: no; legal: yes, no]
I want to reboot the LCD to make sure we start from a known state',
        'choice' => [
          'yes',
          'no'
        ]
      }
    ]
  }
]
;

