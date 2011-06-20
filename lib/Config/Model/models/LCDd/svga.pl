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
    'name' => 'LCDd::svga',
    'element' => [
      'Mode',
      {
        'value_type' => 'enum',
        'upstream_default' => 'G320x240x256',
        'type' => 'leaf',
        'description' => 'svgalib mode to use [default: G320x240x256; legal: supported svgalib modes]',
        'choice' => [
          'supportedsvgalibmodes'
        ]
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '20x4',
        'type' => 'leaf',
        'description' => 'set display size [default: 20x4]'
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '500',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial contrast [default: 500; legal: 0 - 1000]
Can be set but does not change anything internally'
      },
      'Brightness',
      {
        'value_type' => 'integer',
        'min' => '1',
        'upstream_default' => '1000',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial brightness [default: 1000; legal: 1 - 1000]'
      },
      'OffBrightness',
      {
        'value_type' => 'integer',
        'min' => '1',
        'upstream_default' => '500',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial off-brightness [default: 500; legal: 1 - 1000]
This value is used when the display is normally
switched off in case LCDd is inactive'
      }
    ]
  }
]
;
