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
    'name' => 'LCDd::serialPOS',
    'element' => [
      'Device',
      {
        'value_type' => 'uniline',
        'default' => '/dev/lcd',
        'type' => 'leaf',
        'description' => 'Device to use in serial modea [default: /dev/lcd]'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '16x2',
        'type' => 'leaf',
        'description' => 'Specifies the size of the display in characters. [default: 16x2]'
      },
      'Type',
      {
        'value_type' => 'enum',
        'upstream_default' => 'AEDEX',
        'type' => 'leaf',
        'description' => 'Set the communication protocol to use with the POS display.
[default: AEDEX; legal: IEE, Epson, Emax, IBM, LogicControls, Ultimate]',
        'choice' => [
          'IEE',
          'Epson',
          'Emax',
          'IBM',
          'LogicControls',
          'Ultimate'
        ]
      },
      'Speed',
      {
        'value_type' => 'enum',
        'upstream_default' => '9600',
        'type' => 'leaf',
        'description' => 'communication baud rate with the display [default: 9600; legal: 1200, 2400, 19200, 115200]',
        'choice' => [
          '1200',
          '2400',
          '19200',
          '115200'
        ]
      }
    ]
  }
]
;

