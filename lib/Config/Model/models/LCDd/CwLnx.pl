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
    'name' => 'LCDd::CwLnx',
    'element' => [
      'Model',
      {
        'value_type' => 'enum',
        'upstream_default' => '12232',
        'type' => 'leaf',
        'description' => 'Select the LCD model [default: 12232; legal: 12232, 12832, 1602]',
        'choice' => [
          '12232',
          '12832',
          '1602'
        ]
      },
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/ttyUSB0',
        'type' => 'leaf',
        'description' => 'Select the output device to use [default: /dev/lcd]'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'dependingonmodel',
        'type' => 'leaf',
        'description' => 'Select the LCD size [default: depending on model: 12232: 20x4, 12832: 21x4, 1602: 16x2]'
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => '19200',
        'type' => 'leaf',
        'description' => 'Set the communication speed [default: 19200; legal: 9600, 19200]',
        'choice' => [
          '9600',
          '19200'
        ]
      },
      'Reboot',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Reinitialize the LCD\'s BIOS [default: no; legal: yes, no]
normally you shouldn\'t need this',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'Keypad',
      {
        'value_type' => 'uniline',
        'default' => 'yes',
        'type' => 'leaf',
        'description' => 'If you have a keypad connected. Keypad layout is currently not
configureable from the config file.'
      },
      'keypad_test_mode',
      {
        'value_type' => 'uniline',
        'default' => 'yes',
        'type' => 'leaf',
        'description' => 'If you have a non-standard keypad you can associate any keystrings to keys.
There are 6 input keys in the CwLnx hardware that generate characters
from \'A\' to \'F\'.

The following is the built-in default mapping hardcoded in the driver.
You can leave those unchanged if you have a standard keypad.
You can change it if you want to report other keystrings or have a non
standard keypad.
KeyMap_A=Up
KeyMap_B=Down
KeyMap_C=Left
KeyMap_D=Right
KeyMap_E=Enter
KeyMap_F=Escape
keypad_test_mode permits to test keypad assignement
Default value is no'
      }
    ]
  }
]
;

