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
    'name' => 'LCDd::imonlcd',
    'element' => [
      'Protocol',
      {
        'value_type' => 'uniline',
        'default' => '0',
        'type' => 'leaf',
        'description' => 'Specify which iMon protocol should be used [legal: 0=15c2:ffdc device,
1=15c2:0038 device; default: 0]'
      },
      'OnExit',
      {
        'value_type' => 'uniline',
        'default' => '2',
        'type' => 'leaf',
        'description' => 'Set the exit behavior [legal: 0=leave shutdown message, 1=show the big clock,
2=blank device; default: 1]'
      },
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/lcd0',
        'type' => 'leaf',
        'description' => 'Select the output device to use [default: /dev/lcd0]'
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '200',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Select the displays contrast [default: 200; legal: 0-1000]'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '96x16',
        'type' => 'leaf',
        'description' => 'Specify the size of the display in pixels [default: 96x16]'
      },
      'Backlight',
      {
        'value_type' => 'enum',
        'upstream_default' => 'on',
        'type' => 'leaf',
        'description' => 'Set the backlight state [default: on; legal: on, off]',
        'choice' => [
          'on',
          'off'
        ]
      },
      'DiscMode',
      {
        'value_type' => 'uniline',
        'default' => '0',
        'type' => 'leaf',
        'description' => 'Set the disc mode [legal: 0=spin the "slim" disc - two disc segments,
1=their complement spinning; default: 0]'
      }
    ]
  }
]
;

