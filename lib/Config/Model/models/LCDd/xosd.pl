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
    'name' => 'LCDd::xosd',
    'element' => [
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '20x4',
        'type' => 'leaf',
        'description' => 'set display size [default: 20x4]'
      },
      'Offset',
      {
        'value_type' => 'uniline',
        'upstream_default' => '0x0',
        'type' => 'leaf',
        'description' => 'Offset in pixels from the top-left corner of the monitor [default: 0x0]'
      },
      'Font',
      {
        'value_type' => 'uniline',
        'default' => '-*-terminus-*-r-*-*-*-320-*-*-*-*-*',
        'type' => 'leaf',
        'description' => 'X font to use, in XLFD format, as given by "xfontsel"'
      }
    ]
  }
]
;

