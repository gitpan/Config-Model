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
    'name' => 'LCDd::t6963',
    'element' => [
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '20x6',
        'type' => 'leaf',
        'description' => 'set display size '
      },
      'Port',
      {
        'value_type' => 'uniline',
        'upstream_default' => '0x378',
        'type' => 'leaf',
        'description' => 'port to use '
      },
      'ECPlpt',
      {
        'value_type' => 'enum',
        'upstream_default' => 'yes',
        'type' => 'leaf',
        'description' => 'Is ECP mode on? ',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'graphic',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Use graphics? ',
        'choice' => [
          'yes',
          'no'
        ]
      }
    ]
  }
]
;

