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
    'name' => 'LCDd::IOWarrior',
    'element' => [
      'Size',
      {
        'value_type' => 'uniline',
        'default' => '20x4',
        'type' => 'leaf',
        'description' => 'display dimensions'
      },
      'SerialNumber',
      {
        'value_type' => 'uniline',
        'default' => '00000674',
        'type' => 'leaf',
        'description' => 'serial number [exactly as listed by usbview]
(if not given, the 1st IOWarrior found gets used)'
      },
      'ExtendedMode',
      {
        'value_type' => 'uniline',
        'default' => 'yes',
        'type' => 'leaf',
        'description' => 'If you have an HD66712, a KS0073 or an other \'almost HD44780-compatible\',
set this flag to get into extended mode (4-line linear).'
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
      }
    ]
  }
]
;
