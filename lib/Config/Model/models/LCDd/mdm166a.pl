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
    'name' => 'LCDd::mdm166a',
    'element' => [
      'Clock',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Show self-running clock after LCDd shutdown
Possible values: [default: no; legal: no, small, big]',
        'choice' => [
          'no',
          'small',
          'big'
        ]
      },
      'Dimming',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Dimm display, no dimming gives full brightness [default: no, legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      },
      'OffDimming',
      {
        'value_type' => 'enum',
        'upstream_default' => 'no',
        'type' => 'leaf',
        'description' => 'Dimm display in case LCDd is inactive [default: no, legal: yes, no]',
        'choice' => [
          'yes',
          'no'
        ]
      }
    ]
  }
]
;

