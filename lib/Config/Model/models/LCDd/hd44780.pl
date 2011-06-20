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
    'name' => 'LCDd::hd44780',
    'element' => [
      'ConnectionType',
      {
        'value_type' => 'uniline',
        'default' => '4bit',
        'type' => 'leaf',
        'description' => 'Select what type of connection. See documentation for types.'
      },
      'Port',
      {
        'value_type' => 'uniline',
        'default' => '0x378',
        'type' => 'leaf',
        'description' => 'Port where the LPT is [ususal: 0x278, 0x378 and 0x3BC]'
      },
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/ttyS0',
        'type' => 'leaf',
        'description' => 'Device of the serial interface [default: /dev/lcd]'
      },
      'Speed',
      {
        'value_type' => 'uniline',
        'default' => '0',
        'type' => 'leaf',
        'description' => 'Bitrate of the serial port (0 for interface default)'
      },
      'Keypad',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'If you have a keypad connected.
You may also need to configure the keypad layout further on in this file.'
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '500',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial contrast (bwctusb and lcd2usb) [default: 500; legal: 0 - 1000]'
      },
      'Brightness',
      {
        'value_type' => 'uniline',
        'upstream_default' => '0',
        'type' => 'leaf',
        'description' => 'Set brightness of the backlight (lcd2usb only) [default: 0; legal 0 - 1000]'
      },
      'OffBrightness',
      {
        'value_type' => 'uniline',
        'default' => '0',
        'type' => 'leaf'
      },
      'Backlight',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'If you have a switchable backlight.'
      },
      'OutputPort',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'If you have the additional output port ("bargraph") and you want to
be able to control it with the lcdproc OUTPUT command'
      },
      'Lastline',
      {
        'value_type' => 'enum',
        'upstream_default' => 'true',
        'type' => 'leaf',
        'description' => 'Specifies if the last line is pixel addressable or it controls an
underline effect. [default: true (= pixel addressable); legal: yes, no]',
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
        'description' => 'Specifies the size of the LCD.
In case of multiple combined displays, this should be the total size.'
      },
      'vspan',
      {
        'value_type' => 'uniline',
        'default' => '2,2',
        'type' => 'leaf',
        'description' => 'For multiple combined displays: how many lines does each display have.
Vspan=2,2 means both displays have 2 lines.'
      },
      'ExtendedMode',
      {
        'value_type' => 'uniline',
        'default' => 'yes',
        'type' => 'leaf',
        'description' => 'If you have an HD66712, a KS0073 or an other \'almost HD44780-compatible\',
set this flag to get into extended mode (4-line linear).'
      },
      'LineAddress',
      {
        'value_type' => 'uniline',
        'upstream_default' => '0x20',
        'type' => 'leaf',
        'description' => 'In extended mode, on some controllers like the ST7036 (in 3 line mode)
the next line in DDRAM won\'t start 0x20 higher. [default: 0x20]'
      },
      'CharMap',
      {
        'value_type' => 'uniline',
        'default' => 'hd44780_default',
        'type' => 'leaf',
        'description' => 'Character map to to map ISO-8859-1 to the LCD\'s character set
[default: hd44780_default; legal: hd44780_default, hd44780_euro,
 ea_ks0073, sed1278f_0b, hd44780_koi8_r ]'
      },
      'DelayMult',
      {
        'value_type' => 'uniline',
        'default' => '2',
        'type' => 'leaf',
        'description' => 'If your display is slow and cannot keep up with the flow of data from
LCDd, garbage can appear on the LCDd. Set this delay factor to 2 or 4
to increase the delays. Default: 1.'
      },
      'KeepAliveDisplay',
      {
        'value_type' => 'uniline',
        'default' => '0',
        'type' => 'leaf',
        'description' => 'Some displays (e.g. vdr-wakeup) need a message from the driver to that it
is still alive. When set to a value bigger then null the character in the
upper left corner is updated every <KeepAliveDisplay> seconds. Default: 0.'
      },
      'RefreshDisplay',
      {
        'value_type' => 'uniline',
        'default' => '5',
        'type' => 'leaf',
        'description' => 'If you experience occasional garbage on your display you can use this
option as workaround. If set to a value bigger than null it forces a
full screen refresh <RefreshDiplay> seconds. Default: 0.'
      },
      'DelayBus',
      {
        'value_type' => 'uniline',
        'default' => 'true',
        'type' => 'leaf',
        'description' => 'You can reduce the inserted delays by setting this to false.
On fast PCs it is possible your LCD does not respond correctly.
Default: true.'
      },
      'KeyMatrix_4_1',
      {
        'value_type' => 'uniline',
        'default' => 'Enter',
        'type' => 'leaf',
        'description' => 'If you have a keypad you can assign keystrings to the keys.
See documentation for used terms and how to wire it.
For example to give directly connected key 4 the string "Enter", use:
  KeyDirect_4=Enter
For matrix keys use the X and Y coordinates of the key:
  KeyMatrix_1_3=Enter'
      },
      'KeyMatrix_4_2',
      {
        'value_type' => 'uniline',
        'default' => 'Up',
        'type' => 'leaf'
      },
      'KeyMatrix_4_3',
      {
        'value_type' => 'uniline',
        'default' => 'Down',
        'type' => 'leaf'
      },
      'KeyMatrix_4_4',
      {
        'value_type' => 'uniline',
        'default' => 'Escape',
        'type' => 'leaf'
      }
    ]
  }
]
;
