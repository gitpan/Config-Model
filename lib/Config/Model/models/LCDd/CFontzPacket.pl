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
    'name' => 'LCDd::CFontzPacket',
    'element' => [
      'Model',
      {
        'value_type' => 'enum',
        'upstream_default' => '633',
        'type' => 'leaf',
        'description' => 'Select the LCD model [default: 633; legal: 533, 631, 633, 635]',
        'choice' => [
          '533',
          '631',
          '633',
          '635'
        ]
      },
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/ttyUSB0',
        'type' => 'leaf',
        'description' => 'Select the output device to use [default: /dev/lcd]'
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
      'Reboot',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Reinitialize the LCD\'s BIOS on driver start. [default: no; legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'USB',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Enable the USB flag if the device is connected to an USB port. For
serial ports leave it disabled. [default: no; legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'OldFirmware',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Very old 633 firmware versions do not support partial screen updates using
\'Send Data to LCD\' command (31). For those devices it may be necessary to
enable this flag. [default: no; legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'Size',
      {
        'value_type' => 'uniline',
        'default' => '20x4',
        'type' => 'leaf',
        'description' => 'Override the LCD size known for the selected model. Usually setting this
value should not be necessary.'
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => 'dependingonmodel',
        'type' => 'leaf',
        'description' => 'Override the default communication speed known for the selected model.
[default: depending on model; legal: 19200, 115200]',
        'choice' => [
          '19200',
          '115200'
        ]
      }
    ]
  }
]
;

