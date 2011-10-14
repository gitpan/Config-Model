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
        'upstream_default' => '0',
        'type' => 'leaf',
        'description' => 'Specify which iMon protocol should be used '
      },
      'OnExit',
      {
        'value_type' => 'uniline',
        'upstream_default' => '1',
        'type' => 'leaf',
        'description' => 'Set the exit behavior '
      },
      'Device',
      {
        'value_type' => 'uniline',
        'upstream_default' => '/dev/lcd0',
        'type' => 'leaf',
        'description' => 'Select the output device to use '
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '200',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Select the displays contrast '
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '96x16',
        'type' => 'leaf',
        'description' => 'Specify the size of the display in pixels '
      },
      'Backlight',
      {
        'value_type' => 'enum',
        'upstream_default' => 'on',
        'type' => 'leaf',
        'description' => 'Set the backlight state ',
        'choice' => [
          'on',
          'off'
        ]
      },
      'DiscMode',
      {
        'value_type' => 'uniline',
        'upstream_default' => '0',
        'type' => 'leaf',
        'description' => 'Set the disc mode '
      }
    ]
  }
]
;

