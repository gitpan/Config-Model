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
    'name' => 'LCDd::picolcd',
    'element' => [
      'KeyTimeout',
      {
        'value_type' => 'uniline',
        'default' => '500',
        'type' => 'leaf',
        'description' => 'KeyTimeout is the time that LCDd spends waiting for a key press before cycling
through other duties.  Higher values make LCDd use less CPU time and make
key presses more detectable.  Lower values make LCDd more responsive but a
little prone to missing key presses.  500 (.5 second) is the default and a
balanced value.'
      },
      'Brightness',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '1000',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial brightness [default: 1000; legal: 0 - 1000]'
      },
      'Contrast',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '1000',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial contrast [default: 1000; legal: 0 - 1000]'
      },
      'Keylights',
      {
        'value_type' => 'enum',
        'upstream_default' => 'on',
        'type' => 'leaf',
        'description' => 'Light the keys? i[default: on; legal: on, off]',
        'choice' => [
          'on',
          'off'
        ]
      },
      'Key0Light',
      {
        'value_type' => 'enum',
        'upstream_default' => 'on',
        'type' => 'leaf',
        'description' => 'If Keylights is on, the you can unlight specific keys below:
Key0 is the directional pad.  Key1 - Key5 correspond to the F1 - F5 keys.
There is no LED for the +/- keys.  This is a handy way to indicate to users
which keys are disabled.  [default: on; legal: on, off]',
        'choice' => [
          'on',
          'off'
        ]
      },
      'Key1Light',
      {
        'value_type' => 'uniline',
        'default' => 'on',
        'type' => 'leaf'
      },
      'Key2Light',
      {
        'value_type' => 'uniline',
        'default' => 'on',
        'type' => 'leaf'
      },
      'Key3Light',
      {
        'value_type' => 'uniline',
        'default' => 'on',
        'type' => 'leaf'
      },
      'Key4Light',
      {
        'value_type' => 'uniline',
        'default' => 'on',
        'type' => 'leaf'
      },
      'Key5Light',
      {
        'value_type' => 'uniline',
        'default' => 'on',
        'type' => 'leaf'
      },
      'LircHost',
      {
        'value_type' => 'uniline',
        'default' => '127.0.0.1',
        'type' => 'leaf',
        'description' => 'Host name or IP address of the LIRC instance that is to receive IR codes
If not set, or set to an empty value, IR support is disabled.'
      },
      'LircPort',
      {
        'value_type' => 'integer',
        'min' => '1',
        'upstream_default' => '8765',
        'max' => '65535',
        'type' => 'leaf',
        'description' => 'UDP port on which LIRC is listening [default: 8765; legal: 1 - 65535]'
      },
      'LircFlushThreshold',
      {
        'value_type' => 'uniline',
        'upstream_default' => '100',
        'type' => 'leaf',
        'description' => 'Threshold in jiffies of synthesized gap that triggers flushing the IR data to lirc
[default: 100 (6.1ms); 0 to suppress]'
      }
    ]
  }
]
;

