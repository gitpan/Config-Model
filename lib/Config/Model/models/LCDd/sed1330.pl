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
    'name' => 'LCDd::sed1330',
    'element' => [
      'Port',
      {
        'value_type' => 'uniline',
        'default' => '0x378',
        'type' => 'leaf',
        'description' => 'Port where the LPT is. Common values are 0x278, 0x378 and 0x3BC'
      },
      'Type',
      {
        'value_type' => 'uniline',
        'default' => 'G321D',
        'type' => 'leaf',
        'description' => 'Type of LCD module (legal: G321D, G121C, G242C, G191D, G2446, SP14Q002)
Note: Currently only tested with G321D & SP14Q002.'
      },
      'CellSize',
      {
        'value_type' => 'enum',
        'upstream_default' => '6x10',
        'type' => 'leaf',
        'description' => 'Width x Height of a character cell in pixels [legal: 6x7 - 8x16; default: 6x10]',
        'choice' => [
          '6x7'
        ]
      },
      'ConnectionType',
      {
        'value_type' => 'enum',
        'upstream_default' => 'classic',
        'type' => 'leaf',
        'description' => 'Select what type of connection [legal: classic, bitshaker; default: classic]',
        'choice' => [
          'classic',
          'bitshaker'
        ]
      }
    ]
  }
]
;

