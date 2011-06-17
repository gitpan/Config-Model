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
    'name' => 'LCDd::curses',
    'element' => [
      'Foreground',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'blue',
        'type' => 'leaf',
        'description' => 'color settings
foreground color [default: blue]'
      },
      'Background',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'cyan',
        'type' => 'leaf',
        'description' => 'background color when "backlight" is off [default: cyan]'
      },
      'Backlight',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'red',
        'type' => 'leaf',
        'description' => 'background color when "backlight" is on [default: red]'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '20x4',
        'type' => 'leaf',
        'description' => 'display size [default: 20x4]'
      },
      'TopLeftX',
      {
        'value_type' => 'uniline',
        'default' => '7',
        'type' => 'leaf',
        'description' => 'What position (X,Y) to start the left top corner at...
Default: (7,7)'
      },
      'TopLeftY',
      {
        'value_type' => 'uniline',
        'default' => '7',
        'type' => 'leaf'
      },
      'UseACS',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'use ASC symbols for icons & bars [default: no; legal, yes, no]'
      },
      'DrawBorder',
      {
        'value_type' => 'enum',
        'upstream_default' => 'yes',
        'type' => 'leaf',
        'description' => 'draw Border [default: yes; legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      }
    ]
  }
]
;

